---
title: Learning Python
date: '2015-01-13'
tags:
- beginner
- guide
---

# Learning Python

## Fundamentals

- [Pluralsight] course: [Python Fundamentals]
  Highlights:
  - Module 3: "Strings and Collections"
  - Module 6: "Collections"
  - Module 7: "Handling exceptions"
  - Module 8: "Iterables"
  - Module 9: "Classes"
- [Pluralsight] course: [Python - Beyond the Basics]

## Web

### Flask

- [Pluralsight] course: [Introduction to the Flask Microframework]

**Highlights**

```python
# Application container
flask.Flask()

# request - Werzeug or Flask?
flask.request.form
flask.request.args
flask.request.cookies
flask.request.headers
flask.request.files
flask.request.method

app.logger.debug(self, msg, *args, **kwargs)
app.logger.setLevel(self, level)
flask.render_template(template_name_or_list, **context)
flask.url_for(endpoint, **values)
flask.redirect(location, code = 302, Response = None)
flask.flash(message, category = 'message')
```

#### Flask Larger Apps

- [Flask Docs: Larger Applications]
- [Matt Wright: How I Structure My Flask Applications], and [files](https://github.com/mattupstate/overholt)
- [Armin Ronacher: Large app how to]
- [DigitalOcean: How To Structure Large Flask Applications]

[Pluralsight]: http://www.pluralsight.com
[Python Fundamentals]: http://www.pluralsight.com/courses/python-fundamentals
[Introduction to the Flask Microframework]: http://www.pluralsight.com/courses/flask-micro-framework-introduction
[Python - Beyond the Basics]: http://www.pluralsight.com/courses/python-beyond-basics
[Matt Wright: How I Structure My Flask Applications]: http://mattupstate.com/python/2013/06/26/how-i-structure-my-flask-applications.html
[Flask Docs: Larger Applications]: http://flask.pocoo.org/docs/0.10/patterns/packages/
[Armin Ronacher: Large app how to]: https://github.com/mitsuhiko/flask/wiki/Large-app-how-to
[DigitalOcean: How To Structure Large Flask Applications]: https://www.digitalocean.com/community/tutorials/how-to-structure-large-flask-applications
