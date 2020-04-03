{-
    | Document type and instances
    | [Document](https://developer.mozilla.org/en-US/docs/Web/API/Document)
-}
module Vanilla.Dom.Document
    ( Document, document
    ) where

import Data.Maybe (Maybe (Just, Nothing))
import Data.Function.Uncurried (Fn3, runFn3)
import Vanilla.Dom.Event (class EventTarget, class FromEventTarget)
import Vanilla.Dom.Node (class Node, class FromNode, class QueryNode)

import Vanilla.Dom.Event as Ev
import Vanilla.Dom.Node as Nd


-- | Document type, which is HTMLDocument or XMLDocument
foreign import data Document :: Type
-- | Document value
foreign import document :: Document

instance docEventTarget :: EventTarget Document where
    addEventListener = Ev.unsafeAddEventListener
    removeEventListener = Ev.unsafeRemoveEventListener
    dispatchEvent = Ev.unsafeDispatchEvent

instance docFromEventTarget :: FromEventTarget Document where
    fromEventTarget = runFn3 fromEventTarget_ Just Nothing
foreign import fromEventTarget_ :: Fn3 (forall a. a -> Maybe a)
                                       (forall a. Maybe a)
                                       Ev.AnyEventTarget
                                       (Maybe Document)

instance docNode :: Node Document where
    textContent = Nd.unsafeTextContent
    childNodes = Nd.unsafeChildNodes

instance docFromNode :: FromNode Document where
    fromNode = runFn3 fromNode_ Just Nothing
foreign import fromNode_ :: Fn3 (forall a. a -> Maybe a)
                                (forall a. Maybe a)
                                Nd.AnyNode
                                (Maybe Document)

instance docQuery :: QueryNode Document where
    querySelector = Nd.unsafeQuerySelector
