-- [nfnl] fnl/conjure-spec/client/clojure/nrepl/action_spec.fnl
local _local_1_ = require("plenary.busted")
local describe = _local_1_.describe
local it = _local_1_.it
local assert = require("luassert.assert")
local stub = require("luassert.stub")
local config = require("conjure.config")
local original_get_in_fn = config["get-in-fn"]
local get_in_fn_stub = stub(config, "get-in-fn")
get_in_fn_stub.invokes(original_get_in_fn)
local action_cfg = get_in_fn_stub.on_call_with({"client", "clojure", "nrepl"})
local test_current_form_names = {"test-symbol-x", "test-symbol-y"}
local function _2_(args)
  if ((_G.type(args) == "table") and (args[1] == "test") and (args[2] == "current_form_names")) then
    return test_current_form_names
  else
    local _ = args
    return original_get_in_fn(args)
  end
end
action_cfg.returns(_2_)
local action = require("conjure.client.clojure.nrepl.action")
local function _4_()
  local function _5_()
    local function _6_()
      return assert.are.equals(nil, action["extract-test-name-from-form"](""))
    end
    it("deftest form with missing name", _6_)
    local function _7_()
      return assert.are.equals("foo", action["extract-test-name-from-form"]("(test-symbol-x foo (+ 10 20))"))
    end
    it("normal deftest form", _7_)
    local function _8_()
      return assert.are.equals("foo", action["extract-test-name-from-form"]("(test-symbol-y foo (+ 10 20))"))
    end
    it("normal deftest form - using another symbol", _8_)
    local function _9_()
      return assert.are.equals("foo", action["extract-test-name-from-form"]("(   test-symbol-x  foo  (+ 10 20))"))
    end
    it("deftest form with extra spaces", _9_)
    local function _10_()
      return assert.are.equals("foo", action["extract-test-name-from-form"]("(test-symbol-x ^:kaocha/skip foo :xyz)"))
    end
    return it("deftest form with metadata", _10_)
  end
  describe("extract-test-name-from-form", _5_)
  local function _11_()
    local function _12_()
      for _, t in ipairs({"function", "macro", "special-form", "var", "local", "namespace", "class", "keyword", "resource", "method", "static-method", "field", "static-field", "data-reader"}) do
        assert.are.equals(t, action["clojure->vim-completion"]({candidate = "x", type = t}).kind)
      end
      return nil
    end
    it("uses the full nREPL type as the kind", _12_)
    local function _13_()
      assert.is_nil(action["clojure->vim-completion"]({candidate = "x"}).kind)
      return assert.is_nil(action["clojure->vim-completion"]({candidate = "x", type = ""}).kind)
    end
    it("has no kind when the type is missing or empty", _13_)
    local function _14_()
      return assert.same({word = "map", menu = "clojure.core ([f coll]) ([f c1 c2])", info = "Returns a lazy sequence.", kind = "function"}, action["clojure->vim-completion"]({candidate = "map", type = "function", ns = "clojure.core", doc = "Returns a lazy sequence.", arglists = {"([f coll])", "([f c1 c2])"}}))
    end
    return it("builds the menu and info from the other fields", _14_)
  end
  return describe("clojure->vim-completion", _11_)
end
return describe("client.clojure.nrepl.action", _4_)
