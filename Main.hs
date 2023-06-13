module Main where

import           Options.Applicative
import           GitIssues.Model

-- * Data model

-- | The 'Command' data model is a ADT for representing the executable commands,
-- arguments, options and parameters. Those arguments encapsulated are the
-- baseline for decission on what the application will do.
data Command
  = Report ReportOptions
  | Refine RefineOptions
  | Remove RemoveOptions
  | Pick PickOptions
  | Finish FinishOptions
  | Filter FilterOptions
  deriving Show

-- | Report a new ticket.
newtype ReportOptions
  = ReportOptions
    { reportedMessage :: TicketMessage  -- ^ The exact content of the ticket.
    }
    deriving Show

-- | Edit the existing ticket.
newtype RefineOptions
  = RefineOptions
    { refinedTicket :: Ticket  -- ^ The refined ticket.
    }
    deriving Show

-- | Remove the ticket.
newtype RemoveOptions
  = RemoveOptions
    { removedFilePath :: TicketFilePath  -- ^ The file path of the ticket.
    }
    deriving Show

-- | Pick a ticket, start a feature branch and continue workflow.
newtype PickOptions
  = PickOptions
    { assignedFilePath :: TicketFilePath  -- ^ The file path of the ticket.
    }
    deriving Show

-- | Remove the ticket and merge the feature branch.
newtype FinishOptions
  = FinishOptions
    { closedFilePath :: TicketFilePath  -- ^ The file path of the ticket.
    }
    deriving Show

-- | Browse the tickets by filtering them.
newtype FilterOptions
  = FilterOptions
    { query :: TicketQuery  -- ^ The filteing query.
    }
    deriving Show

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

-- For now just show the internal parsed data model for options.
main :: IO ()
main = do
  print =<< execParser (info issuesCommand (progDesc "The git issues is a swiss army tool for managing tasks and controlling repository history in order to keep track of project progress and workflow."))
