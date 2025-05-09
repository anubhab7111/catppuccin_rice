local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("cpp", {
    s("solution", {
        t({"#include <bits/stdc++.h>", "using namespace std;", "typedef long long ll;", "", "void WrongAns() {", "  "}),
        i(1),
        t({"", "}", "", "int main() {", "  ios::sync_with_stdio(false);", "  cin.tie(NULL);", "  cout.tie(0);", "  cout.precision(10);", "  srand(chrono::high_resolution_clock::now().time_since_epoch().count());", "", "  ll tt = 1;", "  cin >> tt;", "  while (tt--)", "    WrongAns();", "", "  return 0;", "}", ""})
    })
})

