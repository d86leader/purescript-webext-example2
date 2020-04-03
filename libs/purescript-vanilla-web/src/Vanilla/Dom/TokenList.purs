{-
    | Monomorphic list of strings ("tokens"). Used throughout JS API
    | [DOMTokenList](https://developer.mozilla.org/en-US/docs/Web/API/DOMTokenList)
-}
module Vanilla.Dom.TokenList
    ( TokenList
    , tokenListHas, tokenListAdd, tokenListRemove
    ) where

import Data.Unit (Unit)
import Effect (Effect)
import Data.Function.Uncurried (Fn2, runFn2)
import Effect.Uncurried (EffectFn2, runEffectFn2)

-- | TokenList itself
foreign import data TokenList :: Type

-- | Check if token is in class list
-- | [contains](https://developer.mozilla.org/en-US/docs/Web/API/DOMTokenList/contains)
tokenListHas :: String -> TokenList -> Boolean
tokenListHas = runFn2 tokenListHas_
foreign import tokenListHas_ :: Fn2 String TokenList Boolean
-- | Add token to list
-- | [add](https://developer.mozilla.org/en-US/docs/Web/API/DOMTokenList/add)
tokenListAdd :: String -> TokenList -> Effect Unit
tokenListAdd = runEffectFn2 tokenListAdd_
foreign import tokenListAdd_ :: EffectFn2 String TokenList Unit
-- | Remove token from list
-- | [remove](https://developer.mozilla.org/en-US/docs/Web/API/DOMTokenList/remove)
tokenListRemove :: String -> TokenList -> Effect Unit
tokenListRemove = runEffectFn2 tokenListRemove_
foreign import tokenListRemove_ :: EffectFn2 String TokenList Unit
