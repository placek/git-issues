module GitIssues.Model where

import           CMark     as M
import           Data.Char (isAlphaNum)
import qualified Data.Text as T

-- * Low level data types

-- | Ticket file path.
type TicketFilePath = FilePath

-- | Ticket content.
data TicketMessage = Message T.Text T.Text deriving Show

getDocumentTitle :: Node -> T.Text
getDocumentTitle (M.Node _ M.DOCUMENT nodes) = title nodes
  where title :: [M.Node] -> T.Text
        title []    = ""
        title (n:_) = getNodeTitle n
        getNodeTitle :: M.Node -> T.Text
        getNodeTitle (M.Node _ _ [Node _ (TEXT t) _]) = t
        getNodeTitle _                                = ""
getDocumentTitle _ = ""

textToMessage :: T.Text -> TicketMessage
textToMessage text = Message normalisedID normalisedText
  where nodes = commonmarkToNode [optNormalize] text
        normalisedText = nodeToCommonmark [optNormalize, optSafe] (Just 80) nodes
        normalisedID = T.filter isIDChar . T.toLower . T.intercalate "-" . T.words . getDocumentTitle $ nodes
        isIDChar '-' = True
        isIDChar a   = isAlphaNum a

-- | Ticket query string.
type TicketQuery = T.Text

-- * Ticket data representation

-- | The ticket.
data Ticket = Ticket TicketFilePath TicketMessage deriving Show

-- * Option parser data model

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
