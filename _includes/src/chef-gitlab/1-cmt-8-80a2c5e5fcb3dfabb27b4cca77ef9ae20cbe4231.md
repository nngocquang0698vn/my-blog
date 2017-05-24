`.kitchen.yml`:
```yaml
suites:
  - name: default
    # ...
  - name: custom-group
    run_list:
      - recipe[user-cookbook::default]
    verifier:
      inspec_tests:
        - test/integration/custom-group
    attributes:
      group: 'test'
  - name: hello
    run_list:
      - recipe[user-cookbook::default]
    verifier:
      inspec_tests:
        - test/integration/hello
    attributes:
      hello: true
```

