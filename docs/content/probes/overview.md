# Probes

Probes run tests.

## Behavior of a Probe

* In case of multiples IP resolved by a DNS record, each of them will be tested.


## Results

### Success

### Timeout

### Error

#### Probe Error Code
An error can be a expected result. eg: The absence of a specific DNS record can be put under surveillance. While this record is absent, the probe will return an error.
For some error types, a probe can add a `ProbeCode` (`probeinfo.probepode`, therefore you can now create an assertion on this probecode. If the assertion succeeded the test will be set as success.


