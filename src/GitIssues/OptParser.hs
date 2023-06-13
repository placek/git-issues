module GitIssues.OptParser where

import           GitIssues.Model
import           Options.Applicative

-- * Generic parsers

-- | Parse a file path.
filePathArgument :: Parser TicketFilePath
filePathArgument = argument str ( metavar "FILE" <> help "The issue file." )

-- | Parse a ticket content.
messageOption :: Parser TicketMessage
messageOption = strOption ( long "message" <> short 'm' <> metavar "MESSAGE" <> help "The message - body of the issue." )

-- | Parse a ticket.
ticketOptions :: Parser Ticket
ticketOptions = Ticket <$> filePathArgument <*> messageOption

-- | Parse a filtering query.
queryOption :: Parser TicketQuery
queryOption = argument str ( metavar "QUERY" <> help "The query expression." )

-- * Per-commmand parsers

-- | Parse a 'report' command options.
reportOptions :: Parser ReportOptions
reportOptions = ReportOptions <$> messageOption

-- | Parse a 'refine' command options.
refineOptions :: Parser RefineOptions
refineOptions = RefineOptions <$> ticketOptions

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
