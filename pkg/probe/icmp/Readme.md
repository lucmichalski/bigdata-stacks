# Vigie - Executor Step

>Step for execute a Ping Request

# Ping Request
## Input
In your yaml file, you can use:
### Request Parameters
```yaml
  - host: Host 
  - count: How many ping

```
### Requests Examples
```yaml

name: Title of TestSuite
testcases:

- name: Ping Localhost
  steps:
  - type: ping
    host: 127.0.0.1
    assertions:
    - result.Contact ShouldContainSubstring OK
    - result.timeseconds ShouldBeLessThan 1


```
*NB: to post a file with multipart_form, prefix the path to the file with '@'*

## Result Output

```
    result.Contact
	result.MinRtt 
	result.AvgRtt
	result.Rtt
	result.MaxRtt
	result.PacketLoss
	result.PacketsRecv
	result.IPAddr
```

### Description
 - `result.Contact`: Réponse au ping
 - `result.MinRtt `: Mini RTT (en seconde)
 - `result.AvgRtt`:  
 - `result.Rtt`:  RTT is an alias from AvgRTT
 - `result.MaxRtt`:  
 - `result.PacketLoss`:  
 - `result.PacketsRecv`:  
 - `result.IPAddr`:  
 - `result.TimeSeconds`: 
 - `result.TimeHuman`: 
 - `result.Err`: 
### Result Example

 - `result.Contact`: OK
 - `result.MinRtt `: 0.00011006
 - `result.AvgRtt`:  0.00020036
 - `result.Rtt`:  RTT is an alias from AvgRTT
 - `result.MaxRtt`:  
 - `result.PacketLoss`:  0
 - `result.PacketsRecv`:  5
 - `result.IPAddr`:  127.0.0.1
 - `result.TimeSeconds`: 
 - `result.TimeHuman`: 
 - `result.Err`:
  
## Default assertion

```yaml
result.statuscode ShouldEqual 200
```
