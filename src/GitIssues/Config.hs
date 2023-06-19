module GitIssues.Config where

import           System.Environment (lookupEnv)

getGitIssuesDirectoryPathFromEnvironment :: IO (Maybe String)
getGitIssuesDirectoryPathFromEnvironment = lookupEnv "GIT_ISSUES_DIR"

getGitCommiterNameFromEnvironment :: IO (Maybe String)
getGitCommiterNameFromEnvironment = lookupEnv "GIT_COMMITTER_NAME"

getGitCommiterEmailFromEnvironment :: IO (Maybe String)
getGitCommiterEmailFromEnvironment = lookupEnv "GIT_COMMITTER_EMAIL"
