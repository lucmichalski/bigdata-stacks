package teststruct

import "time"

type Task struct {
	TestSuite *TestSuite
	TestCase  *TestCase
	TestStep  *TestStep
}

func (t *Task) LockAll() {
	t.TestSuite.Mutex.Lock()
	t.TestCase.Mutex.Lock()
	t.TestStep.Mutex.Lock()
}

func (t *Task) UnlockAll() {
	t.TestStep.Mutex.Unlock()
	t.TestCase.Mutex.Unlock()
	t.TestSuite.Mutex.Unlock()
}

func (t *Task) RLockAll() {
	t.TestSuite.Mutex.RLock()
	t.TestCase.Mutex.RLock()
	t.TestStep.Mutex.RLock()
}

func (t *Task) RUnlockAll() {
	t.TestStep.Mutex.RUnlock()
	t.TestCase.Mutex.RUnlock()
	t.TestSuite.Mutex.RUnlock()
}

func (t *Task) WriteMetadataChanges(lastchg time.Time) {

	t.LockAll()
	t.TestStep.LastChange = lastchg
	t.TestSuite.LastChange = lastchg
	t.TestCase.LastChange = lastchg
	t.UnlockAll()

}
