# grammar-analysis

This is meant to be used as a tool assisting the creation of Droplet modes. It parses antlr4 grammar files and searches for
rules that can have other rules as their only children, for instance in C mode,
`additiveExpression -> multiplicativeExpression`. These are used for droppability rule computations. In the future it may
need to support more detailed analysis.
