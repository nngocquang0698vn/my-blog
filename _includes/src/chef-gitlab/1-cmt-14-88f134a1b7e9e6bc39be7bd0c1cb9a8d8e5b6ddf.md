`test/integration/custom-group/default.rb`:
```rb
describe user('jamie') do
  it { should exist }
  its('groups') { should eq ['test'] }
end

describe group('test') do
  it { should exist }
end

describe directory('/home/jamie') do
  it { should exist }
end
```

`test/integration/default/default.rb`:
```rb
describe user('jamie') do
  it { should exist }
  its('groups') { should eq ['jamie'] }
end

describe group('jamie') do
  it { should exist }
end

describe directory('/home/jamie') do
  it { should exist }
end
```

`test/integration/hello/default.rb`:
```rb
describe user('everybody') do
  it { should exist }
  its('groups') { should eq ['everybody'] }
end

describe group('everybody') do
  it { should exist }
end

describe directory('/home/everybody') do
  it { should exist }
end

describe file('/home/everybody/hello.txt') do
  it { should exist }
  its('mode') { should cmp '0600' }
  its('owner') { should eq 'everybody' }
  its('content') { should eq 'hello everybody' }
end
```
