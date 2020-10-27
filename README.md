# Blog Website Project

## Table of contents
1. [Project](#project)
    1. [Description](#description)
    2. [Application Requirements](#app_requirements)
    3. [Stretch Goals](#stretch_goals)

The objective of this project is to work in pairs and create a simple blog website by the end of the week.

## Project <a name="project"></a>
### Description <a name="description"></a>
1. You have until Friday at 3PM to complete your project.

2. Create a Kanban board in JIRA to track your work. Each feature should be documented in this Kanban board, with a story point estimate and simple acceptance criteria. 

3. At the end of the project you will need to present:
    - What your project is called and your basic design ideas
    - How many story points you estimated you could complete within the project timeline
    - How many story points you actually achieved
    - Present a live demo of your blog application
    - Lessons learnt both individually and in running a project

### Application Requirements <a name="app_requirements"></a>

1. Build a simple Node.js application to run your blog using the following technologies:

    Express: https://expressjs.com  
    Handlebars: https://handlebarsjs.com  
    Bootstrap: https://getbootstrap.com  

2. Using a shell script, your blogs should be downloaded using curl and stored on the local file system. Validations on the file size, naming  and file extension should be made as part of your shell script.  

    Please download the blog content from these locations:

        https://academy-project-blogs.s3-eu-west-1.amazonaws.com/teaching_code.doc
        https://academy-project-blogs.s3-eu-west-1.amazonaws.com/IDC.md
        https://academy-project-blogs.s3-eu-west-1.amazonaws.com/milestones.txt

3. Add both unit testing and UI testing using the following technologies:  
    Jest: https://jestjs.io
    Cypress: http://cypress.io

4. Add linting to your project and define some simple coding standards you intend to work to. You should use the following tool:
    ESLint: https://eslint.org

5. Create a pipeline to build and test your application using Jenkins. 


### Stretch Goals <a name="stretch_goals"></a>

1. Automatically push your application to Netlify: http://netlify.com

2. Add test reporting, and create a script that will fail your CI pipeline if a new commit has decreased the unit test coverage.

3. Create an API and database to manage the creation, reading, updating and deletion of new blog posts.
```