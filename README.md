# github-actions-git-flow
Template for Github Actions for git-flow branching strategy

## About git-flow
https://nvie.com/posts/a-successful-git-branching-model/

## Github Actions Workflow

### Branches

### Workflows

* main
  * When PR is opened pull images and run sanity checks
  * Tag the images with the `Tag` and push
* dev
  * When PR is opend build, test and push image
    * Tag with dev and datetime (YYYY-MM-DD-HH-MM)
  * When commit is tagged open PR into main
* feat
  * Feature branches

### Settings in Github

* [ ] Settings -> Pull Requests
  * Always suggest updating pull request branches
  * Allow auto-merge
* [ ] Settings ->  
  Actions -> General -> 
  * Fork pull request workflows from outside collaborators -> Require approval for all outside collaborators
  * Workflow permissions - > Read repository contents and packages permissions
  * Allow GitHub Actions to create and approve pull requests
* [ ] Settings ->  
  * Branches -> Branch protection rule -> 
  * Require a pull request before merging
  * Require status checks to pass before merging
  * Require branches to be up to date before merging
  * ⚠️ Status check will only show up if the Workflow file is in the default branch
