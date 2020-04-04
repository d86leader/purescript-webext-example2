{-
    | Document type and instances
    | [Document](https://developer.mozilla.org/en-US/docs/Web/API/Document)
-}
module Vanilla.Dom.Document
    ( Document, document, body
    , createElement
    ) where

import Data.Maybe (Maybe (Just, Nothing))
import Data.Function.Uncurried (Fn3, runFn3)
import Effect (Effect)
import Effect.Uncurried (EffectFn1, runEffectFn1)
import Vanilla.Dom.Element (Element)
import Vanilla.Dom.Event (class EventTarget, class FromEventTarget)
import Vanilla.Dom.Node (class Node, class FromNode, class QueryNode)

import Vanilla.Dom.Event as Ev
import Vanilla.Dom.Node as Nd


-- | Document type, which is HTMLDocument or XMLDocument
foreign import data Document :: Type
-- | Document value
foreign import document :: Document
-- | Body in document.
-- | [Document.body](https://developer.mozilla.org/en-US/docs/Web/API/Document/body)
foreign import body :: Element

-- | Create a new element by tag name. Don't forget to append it to node tree.
-- | [Document.createElement](https://developer.mozilla.org/en-US/docs/Web/API/Document/createElement)
createElement :: String -> Effect Element
createElement = runEffectFn1 createElement_
foreign import createElement_ :: EffectFn1 String Element


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
    appendAnyChild = Nd.unsafeAppendChild

instance docFromNode :: FromNode Document where
    fromNode = runFn3 fromNode_ Just Nothing
foreign import fromNode_ :: Fn3 (forall a. a -> Maybe a)
                                (forall a. Maybe a)
                                Nd.AnyNode
                                (Maybe Document)

instance docQuery :: QueryNode Document where
    querySelector = Nd.unsafeQuerySelector
    querySelectorAll = Nd.unsafeQuerySelectorAll
