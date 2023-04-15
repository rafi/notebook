---
date: '2013-12-13'
tags:
- di
- dependency injection
---
# PHP Dependency Injection research

##### Advantages:

- Makes unit testing and mocking easier (or possible)
- Decouples object instantiation from usage
- Allows for better separation of concerns and higher object cohesion
- Reduces the usage and need for singleton classes which are considered bad by many people

##### Injection types

- Constructor injection
- Setter injection
- Interface injection

##### Hard coded dependency

- Hard to reuse
- Poor isolation
- Hard to test
- A lot of code
- Hard to maintain
- Hard to understand

##### Dependency injection

- Loose coupling
- Reuse of code
- Reduce amount of code
- Clear and Understandable
- **Extremely easy to test**

# Container

Manual Di management is complicated. A container is one solution

## Disclaimer

- Dependency Injection != DI container
- DI container use Service Locator Anti-Pattern
- DI container make code 'less native'
- Powerful tool, use carefully!
- Often manual injection is enough

# Singletons vs DI Containter [(Kohana Thread)](http://forum.kohanaframework.org/discussion/10468/singletons-vs-dependency-injection-container/p1)

Frameworks like Laravel and Symfony have DI/IoC containers at their core, and to be honest this is sort of inevitable too for Kohana, I think, along with namespaces, dumping the empty class definitions, etc. But then, all frameworks start looking the same ...

Silex [extends](https://github.com/fabpot/Silex/blob/master/src/Silex/Application.php#L54) Pimple (A very simple DIC, see below).

### Why singleton is a bad design pattern
Singletons pollute the global scope and couple objects together, for ex. creating unit tests for coupled objects is hard to impossible. That's one reason why singletons are bad.

Singletons and static methods are impossible to mock, hence impossible to test properly. We do plan on addressing it in the future.

But also I'm not convinced that DI containers are the way to go either...

Arguably this is more of a problem with Kohana than singletons for unit tests as opposed to scenario testing. Take the Route test, for example, where `Route::cache()` depends on `Kohana::cache()` and there's no means of injecting a caching object instead; or other dependencies, like `Request` tests that uses `Num::bytes()`, or unmocked `Route` for that matter (unless I'm reading these test wrong). I guess it depends on how fine-grained you want/need to be with the tests. I can't see Kohana users giving up on static methods anytime soon, though!

Singletons are bad because they are impossible to properly test with and against.

- http://code.google.com/p/google-singleton-detector/wiki/WhySingletonsAreControversial
- Author of PHPUnit also advises against it http://sebastian-bergmann.de/archives/882-Testing-Code-That-Uses-Singletons.html
- http://misko.hevery.com/2008/12/15/static-methods-are-death-to-testability/

# PHP Libraries

### [Pimple](http://pimple.sensiolabs.org/)

Pimple is a simple di container, about 50 lines of code.

- Define parameters, objects, shared objects, protected params
- Packaging a Container for reusability

### [Aura.Di](https://github.com/auraphp/Aura.Di)

Dependency injection container system with the following features:

- Native support for constructor- and setter-based injection
- Lazy-loading of services
- Inheritable configuration of setters and constructor params

### [kohana-dependencies](https://github.com/Zeelot/kohana-dependencies)

A simple dependency injection container for Kohana 3.3.x

- Create an container from an array or a programmatic API

### [PHP-DI](https://github.com/mnapoli/PHP-DI)

Large one-for-all solution with many features and many dependencies.

- Lot's of features, see possible [definitions](https://github.com/mnapoli/PHP-DI/blob/master/doc/definition.md)

## [Auryn](https://github.com/rdlowrey/Auryn)

Flexible recursive dependency injector.

- Injection definitions, type-hint aliasing, parameters, global params
- Instance sharing, instantiation delegates, injecting for execution, dep resolution

## [Orni\Di](https://github.com/orno/di)

Small but powerful dependency injection container.

- Constructor injection, setter injection, factory closures, automatic dep resolution
- Caching
- Configuration

# Research Findings

## Items

 Library             | Features                      | Pros           | Cons
 ------------------- | ----------------------------- | -------------- | ----
 Pimple              | Simple, params, objects, lazy-load, protect, extend and reuse | Small and simple | Still bound to a container configuration
 Aura.Di             | Lazy-load, constructor params, constructor params inheritance, factories and dependency fulfillment, setter injection | Not heavy and featureful | Bound to a container configuration
 kohana-dependencies | Many features, config by php arrays or programmatic | PHP arrays are nice | Complex and bound to container config
 PHP-DI              | Feature-full: Reflection, annotations, programmatic, php array, YAML | Creative solutions | Heavy, lot's of dependencies
 Auryn               | Many features and definitions | No deps, strong features | Probably does many reflections

## Brainstorm

Dependency injection in it's simplest form, together with the inversion of control rule should be a fundamental practice throughout. However manual injection is tedious and cumbersome. The different containers implement quite nicely many different solutions for describing dependencies before injection. All of them provide a pre-configurable container, one to solve them all.

In our use-case, controllers instantiate a use-case, context, which itself depends on various repositories. With Aura.Di's constructor params injeritance we could describe `RepositoryInterface::__contruct` a single time for all repositories, however the contexts' dependencies would be meticulous. PHP-DI's reflection could allow zero-configuration for context dependencies but PHP-DI is heavy.

Being very disgust from huge configurations, convention-over-configuration is more favorable in this use-case for me. Creating a small dependency resolver in the controller base and using reflection to reveal the contructor parameters. Reflection is costly, but we'll perform it once per-request (as long as one context is being executed) the overhead is insignificant.

### Custom example

```php
// src/core/classes/Vendor/CoreBundle/Controller/API.php
namespace Vendor\CoreBundle\Controller;

class API extends Controller {

	/**
	 * Dependency injector
	 * Uses reflection on required class's construct parameters
	 * Pass any number of arguments after $class_name for dependency invocation
	 *
	 * @param  string  $class_name  Class name to instantiate
	 * @return mixed
	 */
	public function di($class_name)
	{
		// Using controller's base namespace
		$base_ns    = substr_replace(__NAMESPACE__, '', strrpos(__NAMESPACE__, '\\') + 1);
		$class_name = $base_ns.$class_name;

		// Get function's arguments and remove the class_name
		$user_args = func_get_args();
		array_shift($user_args);

		// Reflect on class's construct and iterate through parameters
		$class     = new \ReflectionClass($class_name);
		$construct = $class->getConstructor();
		$params    = $construct->getParameters();
		$args      = [];

		foreach ($params as $param)
		{
			// If parameter has a type-hint, instantiate it
			if ($dep = $param->getClass())
			{
				$args[] = new $dep->name;
			}
			else
			{
				// Otherwise use provided argument in order
				$args[] = array_shift($user_args);
			}
		}

		// Instantiate required class with dynamic arguments
		return $class->newInstanceArgs($args);
	}

}


// src/core/classes/Vendor/CoreBundle/Context/Grid/Create.php
namespace Vendor\CoreBundle\Context\Grid;

class Create {

	private $data;
	private $grid;
	private $grid_repo;
	private $grid_file_repo;

	public function __construct(
		array           $data,
		Model\Foo       $foo_model,
		Repository\Foo  $foo_repo,
	)
	{
		// <Set dependencies here>
	}

	public function execute()
	{
		// <Execute use-case and return output here>
	}

}


// src/foo/classes/Vendor/FooBundle/Controller/API/Foo.php
namespace Vendor\FooBundle\Controller\API;

class Foo extends API {

	public function post_collection()
	{
		// <Handle input here>

		// Inject dependency: Instatiate context with payload, and execute
		$result = $this->di('Context\Grid\Create', $this->_request_payload)
			->execute();
		
		// <Format output here>
	}

}
```
* You can pass the `$this->di()` any number of arguments after the class's name you wish to instantiate.

# Resources

- http://www.slideshare.net/fabpot/dependency-injection-with-php-and-php-53
- http://fabien.potencier.org/talk/19/decouple-your-code-for-reusability-ipc-2008
- http://www.slideshare.net/thecarpenter/dependency-injection-with-php
- http://www.martinfowler.com/articles/injection.html
- http://fabien.potencier.org/article/11/what-is-dependency-injection
- http://misko.hevery.com/2008/07/08/how-to-think-about-the-new-operator
- http://misko.hevery.com/2008/09/10/where-have-all-the-new-operators-gone
- http://misko.hevery.com/2008/09/30/to-new-or-not-to-new

