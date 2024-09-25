Git issues
==========

There is a multitude of tools dedicated to issue tracking, tasks management, bug
reporting, todos keeping, etc. Git issue is an idea to make another one, with
specific goals in mind.

Most of the known issue management tools are focused on the process workflow or
on user experience (or both). I've found no such tool that tries to keep the
project and related work documentation together in one repository, using git
commits blockchain as a history keeper.

Idea
----

Git issues is an attempt to make it possible to have proper, feature-rich tool
allowing users flexibility of the file system with just enough rigor to keep
the issues history alongside the code history.

Git issues is supposed to be an command-line interface (CLI) used as a subset of
git commands that provides sufficient actions for managing both the tasks
lifespan and the simple task-related workflow.

The idea is to achieve the following goals:

* Keep the issues in the same repository as the code. Use the same git history
  for both code and issues.
* Incorporate the issues history into the git history. Use the same git
  commands to browse the issues history as the code history. Use dedicated
  commits for such events like sprint planning, issue creation, issue
  modification, issue resolution, refinement, etc.
* Use dedicated directory to store issues, with a simple structure:
  - One issue per file.
  - Issue file is whatever the user wants it to be: markdown, text, json, yaml,
    etc.
  - Issue file name is the main human-readable issue identifier. **Changing the
    file name is considered a change of the issue!**
  - Issues are stored in a root of the dedicated directory.
  - Issue name is the file name starting with any character except a dot. The
    issue file is therefore a non-hidden file.
  - Any content in the dedicated directory which name starts with a dot is
    considered a metadata, attachment or any other auxiliary file. It is not
    considered an issue, therefore it is not processed by the git issues tool.
  - Any directory inside the dedicated directory which name does not start with
    a dot is considered a category. It is a way to group issues. The category
    can be anything the user wants it to be: a project, a milestone, a sprint,
    an epic, etc.
  - The category can have subcategories, and so on.
  - The category can have metadata, attachments or any other auxiliary files.
  - The issue is considered to be within a category if there is a symlink to
    the issue file in the category directory.
  - The issue can be in multiple categories. Multiple symlinks can point to the
    same issue file. The lifespan of the issue is tracked by its movement
    between categories.
  - Addition, removal or modification of the issue file is considered a change
    of the issue. The issue file is versioned by git.
  - Addition, removal or modification of the symlink is considered a change of
    the issue category. This change is also versioned by git.
* Otherwise the maintainers, users and other contributors to the repository are
  free to organise the issues in any way they want.

Purpose of the tool
-------------------

The purpose of the tool is to provide a simple, yet powerful interface to
manage the issues in the repository. The tool is supposed to be a subset of git
commands, with the same user experience and the same rigor. The tool is supposed
to be a command-line interface (CLI) that can be used in the terminal.

Its main goals are:
* Provide a way to browse history of the issues in the repository.
* Provide a way to identify issues in the repository.
* Provide a way to create, modify, resolve, close, reopen, delete, etc. the
  issues in the repository. This will be an alias tool for modifying files and
  managing symlinks in the categories structures.
