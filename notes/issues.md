# Issues

## mix test.watch warning

symptoms:
- gives error during startup of `mix phx.server`
- can't find a fix...

tried:
- mix_test_watch and mix_test_interactive
- various configurations

solution alternatives:
- live with it
- find a mix_test_watch configuration
- `fswatch lib test | mix test --stale --read-from-stdin`
- something else ??



