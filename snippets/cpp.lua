local ls = require("luasnip"); print("Loading C++ snippets")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local f = ls.function_node

local date = function()
  return { os.date("%Y-%m-%d") }
end

ls.add_snippets("cpp", {
  s("cp", {
    t({
      "#include <bits/stdc++.h>",
      "using namespace std;",
      "",
      "// Defines",
      "#define ff first",
      "#define ss second",
      "#define pb push_back",
      "#define mp make_pair",
      "#define all(x) (x).begin(), (x).end()",
      "#define sz(x) (int)(x).size()",
      "#define rep(i, a, b) for(int i = (a); i < (b); ++i)",
      '#define debug(x) cout << #x << " = " << x << endl',
      "",
      "// Typedefs",
      "typedef long long ll;",
      "typedef pair<int, int> pii;",
      "typedef vector<int> vi;",
      "typedef vector<ll> vll;",
      "typedef vector<pii> vpii;",
      "",
      "// Constants",
      "const int MOD = 1e9 + 7;",
      "const int INF = 1e9;",
      "const ll LLINF = 1e18;",
      "",
      "// Function prototypes",
      "void solve();",
      "",
      "// Main function",
      "int main() {",
      "    ios_base::sync_with_stdio(false);",
      "    cin.tie(nullptr);",
      "    cout.tie(nullptr);",
      "",
      "    int t = 1;",
      "    ",
    }),
    c(1, {
      t({ "cin >> t;", "    " }),
      t(""),
    }),
    t({
      "while (t--) {",
      "        solve();",
      "    }",
      "    return 0;",
      "}",
      "",
      "void solve() {",
      "// Solution",
      "    // Start coding here",
      "    ",
    }),
    i(0),
    t({ "", "}", "", "/*", "Author: " }),
    i(2, "Your Name"),
    t({ "", "Date: " }),
    f(date),
    t({ "", "Problem: " }),
    i(3, "Problem Name/URL"),
    t({ "", "*/" }),
  }),
})
