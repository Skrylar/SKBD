
public enum EventType {
	NoteOn,
	NoteOff
}

public struct Event {
	EventType type;
	uint8 note;
}
