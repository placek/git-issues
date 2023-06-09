module GitIssues where

type TicketID = String
type TicketBody = String
type FilterQuery = String

data Ticket = Ticket TicketID TicketBody
