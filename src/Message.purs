module Message (messageRepr, MessageData) where

import Browser.Runtime (MessageEvent, onMessage)

type MessageData =
    { command :: String
    , beastURL :: String
    }
messageRepr :: MessageEvent MessageData {}
messageRepr = onMessage
