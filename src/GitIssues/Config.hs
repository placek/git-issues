module GitIssues.Config (getCommitterName, getCommitterEmail, getIssuesDirectory) where

import           Control.Applicative ((<|>))
import           System.Environment  (lookupEnv)
import           System.FilePath     ((</>))
import           Toml                (Key, decodeFileEither, string)

type Option = Maybe String
type Location = Maybe FilePath

-- * Location fetchers

-- | Fetches the location of home directory from 'HOME' environment variable.
fetchHomeDir :: IO Location
fetchHomeDir = lookupEnv "HOME"

-- | Fetches the location of XDG configuration directory from 'XDG_CONFIG_HOME' environment variable.
fetchXdgDir :: IO Location
fetchXdgDir = lookupEnv "XDG_CONFIG_HOME"

-- | Fetches the location of current git project directory from 'GIT_DIR' environment variable.
fetchGitDir :: IO Location -- FIXME: this env is sometimes not set: get the PWD and resolve the git root directory
fetchGitDir = lookupEnv "GIT_DIR"

-- * Extractors

-- | Given the file path and the config key this function fetches the value under the key.
extractOptionFromConfig :: Location -- ^ The location pf the file. 'Nothing' means that there is no file, hence 'Nothing' will be returned.
                        -> Key -- ^ The identificator of the option.
                        -> IO Option -- ^ Result encapsulated in the IO action is expected to either has a value or no value at all supressing any potential error messages.
extractOptionFromConfig (Just filePath) key = do
  result <- Toml.decodeFileEither (string key) filePath
  return $ either (const Nothing) Just result
extractOptionFromConfig _ _ = return Nothing

-- | Given a key  this function fetches the value under the key in /etc/gitconfig file.
extractFromGlobalConfigFile :: Key -- ^ The identificator of the option.
                            -> IO Option -- ^ Result encapsulated in the IO action is expected to either has a value or no value at all supressing any potential error messages.
extractFromGlobalConfigFile key = do
  let filePath = Just "/etc/gitconfig"
  extractOptionFromConfig filePath key

-- | Given a key  this function fetches the value under the key in $XDG/git/config file.
extractFromXdgConfigFile :: Key -- ^ The identificator of the option.
                         -> IO Option -- ^ Result encapsulated in the IO action is expected to either has a value or no value at all supressing any potential error messages.
extractFromXdgConfigFile key = do
  location <- fetchXdgDir
  let filePath = (\base -> base </> "git" </> "config") <$> location
  extractOptionFromConfig filePath key

-- | Given a key  this function fetches the value under the key in $HOME/.gitconfig file.
extractFromHomeConfigFile :: Key -- ^ The identificator of the option.
                          -> IO Option -- ^ Result encapsulated in the IO action is expected to either has a value or no value at all supressing any potential error messages.
extractFromHomeConfigFile key = do
  location <- fetchHomeDir
  let filePath = (</> ".gitconfig") <$> location
  extractOptionFromConfig filePath key

-- | Given a key  this function fetches the value under the key in $GIT_DIR/config file.
extractFromGitDirConfigFile :: Key -- ^ The identificator of the option.
                            -> IO Option -- ^ Result encapsulated in the IO action is expected to either has a value or no value at all supressing any potential error messages.
extractFromGitDirConfigFile key = do
  location <- fetchGitDir
  let filePath = (</> "config") <$> location
  extractOptionFromConfig filePath key

-- * Defaults

-- | A default place to store tickets. A '.issues' directory.
defaultGitIssuesDirectoryPath :: Option
defaultGitIssuesDirectoryPath = Just ".issues"

-- * Interface

-- | Fetches the commiter name from known sources of knowlegde: firstly from 'GIT_COMMITTER_NAME', then from 'user.name' config files.
getCommitterName :: IO Option
getCommitterName = do
  fromEnv <- lookupEnv "GIT_COMMITTER_NAME"
  fromGit <- extractFromGitDirConfigFile "user.name"
  fromXdg <- extractFromXdgConfigFile "user.name"
  fromHome <- extractFromHomeConfigFile "user.name"
  fromGlobal <- extractFromGlobalConfigFile "user.name"
  return $ fromEnv <|> fromGit <|> fromXdg <|> fromHome <|> fromGlobal

-- | Fetches the commiter name from known sources of knowlegde: firstly from 'GIT_COMMITTER_EMAIL', then from 'user.email' config files.
getCommitterEmail :: IO Option
getCommitterEmail = do
  fromEnv <- lookupEnv "GIT_COMMITTER_EMAIL"
  fromGit <- extractFromGitDirConfigFile "user.email"
  fromXdg <- extractFromXdgConfigFile "user.email"
  fromHome <- extractFromHomeConfigFile "user.email"
  fromGlobal <- extractFromGlobalConfigFile "user.email"
  return $ fromEnv <|> fromGit <|> fromXdg <|> fromHome <|> fromGlobal

-- | Fetches the commiter name from known sources of knowlegde: firstly from 'GIT_ISSUES_DIRECTORY', then from 'issues.directory' config files.
getIssuesDirectory :: IO Option
getIssuesDirectory = do
  fromEnv <- lookupEnv "GIT_ISSUES_DIRECTORY"
  fromGit <- extractFromGitDirConfigFile "issues.directory"
  fromXdg <- extractFromXdgConfigFile "issues.directory"
  fromHome <- extractFromHomeConfigFile "issues.directory"
  fromGlobal <- extractFromGlobalConfigFile "issues.directory"
  return $ fromEnv <|> fromGit <|> fromXdg <|> fromHome <|> fromGlobal <|> defaultGitIssuesDirectoryPath
