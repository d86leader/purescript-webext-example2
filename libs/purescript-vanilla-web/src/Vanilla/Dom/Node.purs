{-
    | Node class, helper types and their functions. Related entries:
    | - [Node](https://developer.mozilla.org/en-US/docs/Web/API/Node)
-}
module Vanilla.Dom.Node
    ( class Node, textContent, childNodes, appendAnyChild, appendChild
    , unsafeTextContent, unsafeChildNodes, unsafeAppendChild
    , NodeList, nodeListLength, nodeListItem, traverseNodeList
    , AnyNode, class FromNode, fromNode, fromNode'
    , class QueryNode, querySelector, querySelectorAll
    , unsafeQuerySelector, unsafeQuerySelectorAll
    ) where

import Prelude
import Data.Maybe (Maybe, fromJust)
import Data.Function.Uncurried (Fn2, Fn3, runFn2, runFn3)
import Effect (Effect)
import Effect.Uncurried (EffectFn2, runEffectFn2)
import Partial.Unsafe (unsafePartial)
import Vanilla.Dom.Event (class EventTarget)

import Vanilla.Dom.Event as Ev


-- | Class of Node objects, like Element and Document
class EventTarget a <= Node a where
    -- | Text content of node.
    -- | [Node.textContent](https://developer.mozilla.org/en-US/docs/Web/API/Node/textContent)
    textContent :: a -> String
    -- | Children of the node. Careful: this object is live and may change on
    -- | your hands.
    -- | [Node.childNodes](https://developer.mozilla.org/en-US/docs/Web/API/Node/childNodes)
    childNodes :: a -> NodeList
    -- | Add new node to the end of the list of childern. If this node already
    -- | exists in a document, instead move it to this new position. As
    -- | purescript disallows type of a class method to reference the class,
    -- | this has an usafe type which allows you to append a non-node value.
    -- | Please only use this for class implementation, and use 'appendChild'
    -- | when using nodes.
    -- | [Node.appendChild](https://developer.mozilla.org/en-US/docs/Web/API/Node/appendChild)
    appendAnyChild :: forall b. a -- ^ Parent, receiver
                             -> b -- ^ Child to append
                             -> Effect b -- ^ Appended child

-- | Safe appendChild method (see 'appendAnyChild' for unsafe)
appendChild :: forall a b. Node a => Node b
    => a -- ^ Parent, receiver
    -> b -- ^ Child to append
    -> Effect b -- ^ Appended child
appendChild = appendAnyChild

-- | Monomorphic container of nodes.
-- | [NodeList](https://developer.mozilla.org/en-US/docs/Web/API/NodeList)
foreign import data NodeList :: Type
foreign import nodeListLength :: NodeList -> Int
-- | Throws an exception when index out of bounds
nodeListItem :: Int -> NodeList -> AnyNode
nodeListItem = runFn2 nodeListItem_
foreign import nodeListItem_ :: Fn2 Int NodeList AnyNode
-- | Traverse the node list and execute an action, discarding the result
traverseNodeList :: forall f a. Applicative f =>
    (AnyNode -> f a) -> NodeList -> f Unit
traverseNodeList func list = runFn3 traverseNodeList_ (pure unit) func list
foreign import traverseNodeList_ :: forall f a.
    Fn3 (f Unit) (AnyNode -> f a) NodeList (f Unit)


-- | Default JS implementation of Node methods. Use these to quickly
-- | create instances for conforming foreign types.
foreign import unsafeTextContent :: forall a. a -> String
foreign import unsafeChildNodes :: forall a. a -> NodeList
unsafeAppendChild :: forall a b. a -> b -> Effect b
unsafeAppendChild = runEffectFn2 unsafeAppendChild_
foreign import unsafeAppendChild_ :: forall a b. EffectFn2 a b b

-- | Polymorphic type for return values
foreign import data AnyNode :: Type
instance eventTargetAnyNode :: EventTarget AnyNode where
    addEventListener = Ev.unsafeAddEventListener
    removeEventListener = Ev.unsafeRemoveEventListener
    dispatchEvent = Ev.unsafeDispatchEvent
instance anyNode :: Node AnyNode where
    textContent = unsafeTextContent
    childNodes = unsafeChildNodes
    appendAnyChild = unsafeAppendChild

-- | Class to get concrete type of Node class. Instances are to be created with
-- | JS.
class FromNode a where
    fromNode :: AnyNode -> Maybe a
-- | Unsafe wrapper
fromNode' :: forall a. FromNode a => AnyNode -> a
fromNode' et = unsafePartial $ fromJust $ fromNode et


-- | Node which supports querySelector method, like Element and Document
class Node a <= QueryNode a where
    -- | Query child nodes. Returns first match.
    -- | [Element.querySelector](https://developer.mozilla.org/en-US/docs/Web/API/Element/querySelector)
    querySelector :: String -> a -> AnyNode
    -- | Query child nodes. Returns all matches.
    -- | [Element.querySelectorAll](https://developer.mozilla.org/en-US/docs/Web/API/Element/querySelectorAll)
    querySelectorAll :: String -> a -> NodeList

-- | Default JS implementation. Use these to quickly create instances for
-- | conforming foreign types.
unsafeQuerySelector :: forall a. String -> a -> AnyNode
unsafeQuerySelector = runFn2 unsafeQuerySelector_
foreign import unsafeQuerySelector_ :: forall a. Fn2 String a AnyNode
unsafeQuerySelectorAll :: forall a. String -> a -> NodeList
unsafeQuerySelectorAll = runFn2 unsafeQuerySelectorAll_
foreign import unsafeQuerySelectorAll_ :: forall a. Fn2 String a NodeList
