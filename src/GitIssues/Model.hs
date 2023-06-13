module GitIssues.Model where

type TicketFilePath = FilePath
type TicketMessage = String
type TicketQuery = String


data Ticket = Ticket TicketFilePath TicketMessage deriving Show
