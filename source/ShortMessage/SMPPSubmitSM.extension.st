Extension { #name : #SMPPSubmitSM }

{ #category : #'*ShortMessage-Helper' }
SMPPSubmitSM >> toSubmitTPDUDictionary [
	"Convert the SMPP body into a dictionary for encoding"
	| result moreMessages scts  mr |
	result := Dictionary new.
	moreMessages := false.
	mr := 0.

	more_messages_to_send ifNotNil: [
		"TODO: it might not be 0/1 here but actually a bytearray. Fix it in
		the SMPPCodec code"
		self notYetImplemented.
		more_messages_to_send = 1 ifTrue: [moreMessages := true]].
	
	user_message_reference ifNotNil: [
		mr := user_message_reference asInteger bitAnd: 16rFF.
	].

	ShortMessageDataCodingSchemeHelper convertFromSMPPSubmitSM: self toSMS: result.
	scts := DateAndTime now asUTC asGSMSCTS.
	
	^result
		at: 'TP-MTI' put: 1;
		at: 'TP-RP' put: false;
		at: 'TP-SRR' put: false; "TODO: status report"
		at: 'TP-VPFI' put: 0; "TODO: "
		at: 'TP-RD' put: true; "TODO: duplicates?"
		at: 'TP-MR' put: mr;
		at: 'ton' put: dest_addr_ton;
		at: 'npi' put: dest_addr_npi;
		at: 'TP-DA' put: destination_addr;
		at: 'TP-PID' put: protocol_id;
		yourself.
]
