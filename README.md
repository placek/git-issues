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
allowing users flexibility of the TODO.md file with just enough rigor to keep
the issues history alongside the code history.

Git issues is supposed to be an command-line interface (CLI) used as a subset of
git commands that provides sufficient actions for managing both the tasks
lifespan and the simple task-related workflow.

The idea is to achieve the following goals:

* Make use of standard TODO.md file in repository, as a readable "landing-page"
    for anyone who wants to review the currently planned tasks.
* To elaborate on any "todo" make use of a markdown file, located in dedicated
    direcory stored on repository, allowing users to provide detailed
    information on the issue.
* Each todo file has a specific commiting restriction, so the git history will
    be clear on what has been reported, by who, when and how it relates to the
    code history.
* Todos have a tagging system for ease of categorisation and further filtering.
* A todo is a base for creation of the feature branch. Such branch is related to
    this todo, introducing changes on behalf of the todo.
* The merge commit that merges the feature branch to the main branch will be
    provided with the apropiate message explaining changes and the removal of
    the corresponding todo, both as a file and from TODO.md file. This approach
    makes the "done" label/tag irrelevant.
* All the above asumptions are trying to create a structure in repository that
    is human readable even for users that does not use the git issues tool. In
    absence of it the main interface is TODO.md that should always list
    available issues and probably organise them in the manner that fit the
    creators of the repository.
