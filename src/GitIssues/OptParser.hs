module GitIssues.OptParser where

import           Control.Applicative (optional)
import           GitIssues.Model     (Command (..),
                                      FilterOptions (FilterOptions),
                                      FinishOptions (FinishOptions),
                                      PickOptions (PickOptions),
                                      RefineOptions (RefineOptions),
                                      RemoveOptions (RemoveOptions),
                                      ReportOptions (ReportOptions),
                                      TicketFilePath, TicketMessage,
                                      TicketQuery, textToMessage)
import           Options.Applicative (Parser, ParserInfo, argument, command,
                                      execParser, help, info, long, metavar,
                                      progDesc, short, str, strOption,
                                      subparser)

-- * Generic parsers

-- | Parse a file path.
filePathArgument :: Parser TicketFilePath
filePathArgument = argument str ( metavar "FILE" <> help "The issue file." )

-- | Parse a ticket content.
messageOption :: Parser (Maybe TicketMessage)
messageOption = optional $ textToMessage <$> strOption ( long "message" <> short 'm' <> metavar "MESSAGE" <> help "The message - body of the issue." )

-- | Parse a filtering query.
queryOption :: Parser (Maybe TicketQuery)
queryOption = optional $ argument str ( metavar "QUERY" <> help "The query expression." )

-- * Per-commmand parsers

-- | Parse a 'report' command options.
reportOptions :: Parser ReportOptions
reportOptions = ReportOptions <$> messageOption

-- | Parse a 'refine' command options.
refineOptions :: Parser RefineOptions
refineOptions = RefineOptions <$> filePathArgument <*> messageOption

-- | Parse a 'remove' command options.
removeOptions :: Parser RemoveOptions
removeOptions = RemoveOptions <$> filePathArgument

-- | Parse a 'pick' command options.
pickOptions :: Parser PickOptions
pickOptions = PickOptions <$> filePathArgument

-- | Parse a 'finish' command options.
finishOptions :: Parser FinishOptions
finishOptions = FinishOptions <$> filePathArgument

-- | Parse a 'filter' command options.
filterOptions :: Parser FilterOptions
filterOptions = FilterOptions <$> queryOption

-- | Parse any command.
issuesCommand :: Parser Command
issuesCommand = subparser
  ( command "report" (info (Report <$> reportOptions) ( progDesc "Create (aka. report) a new issue." ))
 <> command "refine" (info (Refine <$> refineOptions) ( progDesc "Edit (aka. refine) an issue." ))
 <> command "remove" (info (Remove <$> removeOptions) ( progDesc "Archive (aka. remove) an issue." ))
 <> command "pick" (info (Pick <$> pickOptions) ( progDesc "Pick (aka. start worning on) an issue." ))
 <> command "finish" (info (Finish <$> finishOptions) ( progDesc "Finish (aka. complete) an issue." ))
 <> command "list" (info (Filter <$> filterOptions) ( progDesc "List (aka. filter) issues." ))
  )

-- | The main application parser.
appParser :: ParserInfo Command
appParser = info issuesCommand $ progDesc "The git issues is a swiss army tool for managing tasks and controlling repository history in order to keep track of project progress and workflow."

-- | Get the command wrapped in IO context.
getCommand :: IO Command
getCommand = execParser appParser
