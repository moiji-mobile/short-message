"
I extract information from a GSM03.40 message and can create a messga e again.
"
Class {
	#name : #ShortMessageTPDUHelper,
	#superclass : #Object,
	#category : #'ShortMessage-Helper'
}

{ #category : #'as yet unclassified' }
ShortMessageTPDUHelper class >> encodeDeliver: tpdu [
	| hdr data addr |
	hdr := ((tpdu at: 'TP-RP') asBit) bitShift: 7.
	hdr := hdr bitOr: (((tpdu at: 'TP-UDHI') asBit) bitShift: 6).
	hdr := hdr bitOr: (((tpdu at: 'TP-SRI') asBit) bitShift: 5).
	hdr := hdr bitOr: (((tpdu at: 'TP-MMS') not asBit) bitShift: 2).
	hdr := hdr bitOr: (((tpdu at: 'TP-MTI')  bitAnd: 2r11) bitShift: 0).
	addr := GSMAddress new
				typeOfNumber: (tpdu at: 'ton');
				numberingPlan: (tpdu at: 'npi');
				address: (tpdu at: 'TP-OA');
				yourself.
	data := WriteStream on: ByteArray new.
	(tpdu at: 'TP-UDHI') ifTrue: [
		| udh |
		udh := tpdu at: 'TP-UDH'.
		data
			nextPut: udh size;
			nextPutAll: udh].
	data nextPutAll: (tpdu at: 'TP-UD').
	^ #[] toMessage
		putByte: hdr;
		putByteArray: addr encodeSMSAddress;
		putByte: (tpdu at: 'TP-PID');
		putByte: (tpdu at: 'TP-DCS');
		putByteArray: (tpdu at: 'TP-SCTS');
		putByte: (tpdu at: 'TP-UD-Len');
		putByteArray: data contents;
		toByteArray.
		
]

{ #category : #'as yet unclassified' }
ShortMessageTPDUHelper class >> encodeSubmit: tpdu [
	| hdr data addr |

	hdr := ((tpdu at: 'TP-RP') asBit) bitShift: 7.
	hdr := hdr bitOr: (((tpdu at: 'TP-UDHI') asBit) bitShift: 6).
	hdr := hdr bitOr: (((tpdu at: 'TP-SRR') asBit) bitShift: 5).
	hdr := hdr bitOr: (((tpdu at: 'TP-VPFI') bitAnd: 2r11) bitShift: 3).
	hdr := hdr bitOr: (((tpdu at: 'TP-RD') not asBit) bitShift: 2).
	hdr := hdr bitOr: (((tpdu at: 'TP-MTI')  bitAnd: 2r11) bitShift: 0).

	addr := GSMAddress new
				typeOfNumber: (tpdu at: 'ton');
				numberingPlan: (tpdu at: 'npi');
				address: (tpdu at: 'TP-DA');
				yourself.
	data := WriteStream on: ByteArray new.
	(tpdu at: 'TP-UDHI') ifTrue: [
		| udh |
		udh := tpdu at: 'TP-UDH'.
		data
			nextPut: udh size;
			nextPutAll: udh].
	data nextPutAll: (tpdu at: 'TP-UD').
	^ #[] toMessage
		putByte: hdr;
		putByte: (tpdu at: 'TP-MR');
		putByteArray: addr encodeSMSAddress;
		putByte: (tpdu at: 'TP-PID');
		putByte: (tpdu at: 'TP-DCS');
		putByteArray: ((tpdu at: 'TP-VPFI') > 0 ifTrue: [(tpdu at: 'TP-VP')] ifFalse: [ #[] ]);
		putByte: (tpdu at: 'TP-UD-Len');
		putByteArray: data contents;
		toByteArray.
		
]

{ #category : #'as yet unclassified' }
ShortMessageTPDUHelper class >> extract: aByteArray [
	| mti stream byte |
	stream := aByteArray readStream.
	byte := stream peek.

	mti := byte bitAnd: 2r11.
	mti = 1 ifTrue: [^self extractSubmitFrom: stream].
	mti = 0 ifTrue: [^self extractDeliverFrom: stream].
]

{ #category : #'as yet unclassified' }
ShortMessageTPDUHelper class >> extractDeliverFrom: stream [
	| byte res data udhi len addr |
	res := Dictionary new.
	byte := stream next.
	
	"Read the header"
	res at: 'TP-MTI' put: (byte bitAnd: 2r11).
	res at: 'TP-MMS' put: (byte bitAnd: 2r100) = 0.
	res at: 'TP-SRI' put: (byte bitAnd:  2r100000) > 0.
	udhi := (byte bitAnd: 2r1000000) > 0.
	res at: 'TP-UDHI' put: udhi.
	res at: 'TP-RP' put: (byte bitAnd: 2r10000000) > 0.

	"Read the address"
	addr := GSMAddressCoding decodeSMSAddress: stream.
	res
		at: 'ton' put: addr typeOfNumber;
		at: 'npi' put: addr numberingPlan;
		at: 'TP-OA' put: addr address.

	"Read TP-PID/TP-DCS/TP-SCTS"
	res at: 'TP-PID' put: stream next.
	res at: 'TP-DCS' put: stream next.
	data := stream next: 7.
	(data size = 7)
		ifFalse: [^self error: 'Short Read on Pharo'].
	res at: 'TP-SCTS' put: data.
	
	len := stream next.
	res at: 'TP-UD-Len' put: len.
	udhi ifTrue: [
		len := stream next.
		data := stream next: len.
		(data size = len)
			ifFalse: [^self error: 'Short Read on Pharo'].
		res at: 'TP-UDH' put: data.
	].
	data := stream upToEnd.
	res at: 'TP-UD' put: data.
	^res
]

{ #category : #'as yet unclassified' }
ShortMessageTPDUHelper class >> extractSubmitFrom: stream [
	| byte res data udhi len addr |

	res := Dictionary new.
	byte := stream next.
	
	"Read the header"
	res at: 'TP-MTI' put: (byte bitAnd: 2r11).
	res at: 'TP-RD' put: (byte bitAnd: 2r100)  = 0.
	res at: 'TP-VPFI' put: ((byte bitAnd:  2r11000) bitShift: -3).
	res at: 'TP-SRR' put: (byte bitAnd: 2r100000) > 0.
	udhi := (byte bitAnd: 2r1000000) > 0.
	res at: 'TP-UDHI' put: udhi.
	res at: 'TP-RP' put: (byte bitAnd: 2r10000000) > 0.

	res at: 'TP-MR' put: stream next.

	"Read the address and assume it is TBCD"
	addr := GSMAddressCoding decodeSMSAddress: stream.
	res
		at: 'ton' put: addr typeOfNumber;
		at: 'npi' put: addr numberingPlan;
		at: 'TP-DA' put: addr address.

	"Read TP-PID/TP-DCS"
	res at: 'TP-PID' put: stream next.
	res at: 'TP-DCS' put: stream next.

	(res at: 'TP-VPFI') = 2 ifTrue: [
		res at: 'TP-VP' put: (stream next: 1)].
	
	len := stream next.
	res at: 'TP-UD-Len' put: len.
	udhi ifTrue: [
		len := stream next.
		data := stream next: len.
		(data size = len)
			ifFalse: [^self error: 'Short Read on Pharo'].
		res at: 'TP-UDH' put: data.
	].
	data := stream upToEnd.
	res at: 'TP-UD' put: data.
	^res
]

{ #category : #'as yet unclassified' }
ShortMessageTPDUHelper class >> formatFromGSM7Bit: tpdu on: smppMessage [
	| data bytes udhi |
	data := #[] toMessage.
	
	udhi  := tpdu at: 'TP-UDHI'.
	udhi ifTrue: [
		| udh |
		"Indicate we have a UDH here and assume we know the rest of the class"
		udh := (tpdu at: 'TP-UDH').
		smppMessage esmClass: 2r01000000.
		data
			putByte: udh size;
			putByteArray: udh.
	].
		
	"The last 7bit of the TP-UDH might be empty and this is why there is
	a TP-UD-Len so one can know if the last '0' belongs to the SMS or not.
	We need to truncate the bytearray here and abuse a feature of Squeak
	at this point. To use >>#next:"
	bytes := #[] toMessage.
	bytes
		putByteArray: data;
		putByteArray: (tpdu at: 'TP-UD').
	bytes := GSMDecoding expand: bytes.
	bytes := bytes readStream next: (tpdu at: 'TP-UD-Len').
		
	"With TP-UDHI and 7bit encoding there are some bytes we need to
	skip and re-do now."
	udhi ifTrue: [
		| skip fillBits |
		"Now we need to skip the n-octets of the header and maybe from
		the fill bit as well and put back the original data again."
		skip := (((data size)* 8) \\ 7).
		fillBits := 7 - skip.
		fillBits > 0
			ifTrue: [skip := skip + 1].

		data
			putByteArray: (bytes allButFirst: skip).
		bytes := data.
	].

	^smppMessage
		dataCoding: 0;
		shortMessage: bytes asByteArray;
		yourself
]

{ #category : #'as yet unclassified' }
ShortMessageTPDUHelper class >> formatFromOctets: tpdu on: smppMessage [
	| data  udhi |
	data := #[] toMessage.
	
	udhi  := tpdu at: 'TP-UDHI'.
	udhi ifTrue: [
		| udh |
		"Indicate we have a UDH here and assume we know the rest of the class"
		udh := (tpdu at: 'TP-UDH').
		smppMessage esmClass: 2r01000000.
		data
			putByte: udh size;
			putByteArray: udh.
	].

	data putByteArray: (tpdu at: 'TP-UD').

	^smppMessage
		shortMessage: data asByteArray;
		yourself
]

{ #category : #'as yet unclassified' }
ShortMessageTPDUHelper class >> formatToGSM7Bit: tpdu on: smppMessage [
	| udhi udh dataPacked skipBytes data input padding |
	skipBytes := 0.
	padding := 0.
	udh := #[] toMessage.
	data := #[] toMessage.
	
	input := smppMessage shortMessage asByteArray readStream.
	udhi := (smppMessage esmClass bitAnd: 2r01000000) > 0.

	udhi ifTrue: [
		| len tmp fillBits |
		len := input next.
		tmp := input next: len.
		tmp size = len ifFalse: [
			^self error: 'Short read on UDH'].
		udh putByteArray: tmp.
		data putByte: len.
		data putByteArray: udh.

		skipBytes := (((udh size)* 8) \\ 7).
		fillBits := 7 - skipBytes.
		fillBits > 0 ifTrue: [
			skipBytes := skipBytes + 1.
			padding := 1.
			data putByte: 0]].

	"Does the UDH stop on a 7bit boundary? If not we need to add padding.."
	data putByteArray: input upToEnd asByteArray.
	dataPacked := (GSMEncoding compact: data) allButFirst: skipBytes.

	"Set the data"
	tpdu at: 'TP-UDHI' put: udhi.
	tpdu at: 'TP-UDH' put: udh toByteArray.
	tpdu at: 'TP-UD-Len' put: smppMessage shortMessage size + padding.
	tpdu at: 'TP-UD' put: dataPacked.
]

{ #category : #'as yet unclassified' }
ShortMessageTPDUHelper class >> formatToOctets: tpdu on: smppMessage [ 
	| udhi udh  data input  |

	udh := #[] toMessage.
	data := #[] toMessage.
	
	input := smppMessage shortMessage asByteArray readStream.
	udhi := (smppMessage esmClass bitAnd: 2r01000000) > 0.

	"Take it and remember it separately"
	udhi ifTrue: [
		| len tmp  |
		len := input next.
		tmp := input next: len.
		tmp size = len ifFalse: [
			^self error: 'Short read on UDH'].
		udh putByteArray: tmp].

	data putByteArray: input upToEnd asByteArray.

	"Set the data"
	tpdu at: 'TP-UDHI' put: udhi.
	tpdu at: 'TP-UDH' put: udh toByteArray.
	tpdu at: 'TP-UD-Len' put: smppMessage shortMessage size. "Includes UDH+data"
	tpdu at: 'TP-UD' put: data toByteArray
]
