-- Fixture: writes a file relative to the working directory
vim.fn.writefile({ 'x' }, 'docs-cwd-probe.txt')
