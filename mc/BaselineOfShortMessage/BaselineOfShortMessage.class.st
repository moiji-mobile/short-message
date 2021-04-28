Class {
	#name : #BaselineOfShortMessage,
	#superclass : #BaselineOf,
	#category : #BaselineOfShortMessage
}

{ #category : #baselines }
BaselineOfShortMessage >> baseline: spec [

	<baseline>
	spec
		baseline: 'SMPP'
		with: [ spec repository: 'github://moiji-mobile/smpp-codec:v1/mc' ].

	spec package: 'ShortMessage' with: [ spec requires: #( 'SMPP' ) ].

	spec group: 'default' with: #( 'ShortMessage' )
]
