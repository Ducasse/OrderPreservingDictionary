"
(ConfigurationOfOrderPreservingDictionary project version: #stable) load
"
Class {
	#name : #ConfigurationOfOrderPreservingDictionary,
	#superclass : #Object,
	#instVars : [
		'project'
	],
	#classVars : [
		'LastVersionLoad'
	],
	#category : #ConfigurationOfOrderPreservingDictionary
}

{ #category : #private }
ConfigurationOfOrderPreservingDictionary class >> bootstrapPackage: aString from: aPath [ 
	| repository version |
	repository := MCHttpRepository
				location: aPath
				user: ''
				password: ''.
	repository
		versionReaderForFileNamed: aString , '.mcz'
		do: [:reader | 
			version := reader version.
			version load.
			version workingCopy repositoryGroup addRepository: repository]
]

{ #category : #private }
ConfigurationOfOrderPreservingDictionary class >> ensureMetacello [
	"Bootstrap Gofer (if necessary), bootstrap ConfigurationOfMetacello (using old Gofer API), then load the latest 
	version of Metacello itself."

	Smalltalk at: #MetacelloProject ifAbsent: [
		Smalltalk at: #Gofer ifAbsent: [
			"Current version of Gofer from which to bootstrap - as of 1.0-beta.21"
			self bootstrapPackage: 'Gofer-Core-lr.115' from: 'http://seaside.gemstone.com/ss/metacello' ].
		Smalltalk at: #Gofer ifPresent: [:goferClass | | gofer |
			gofer := goferClass new
				url: 'http://seaside.gemstone.com/ss/metacello';
				yourself.
			[ gofer addPackage: 'ConfigurationOfMetacello' ] on: Warning do: [:ex | ex resume ].
			gofer load ].
		"load 'default' group of Metacello"
		(Smalltalk at: #ConfigurationOfMetacello) perform: #load ]
]

{ #category : #'metacello tool support' }
ConfigurationOfOrderPreservingDictionary class >> isMetacelloConfig [
	"Answer true and the Metacello tools will operate on you"
	
	^true
]

{ #category : #'metacello tool support' }
ConfigurationOfOrderPreservingDictionary class >> lastMetacelloVersionLoad [
	"Answer the last version loaded and the list of packages loaded for that version."

	LastVersionLoad == nil ifTrue: [ LastVersionLoad := nil -> 'default' ].
	^LastVersionLoad
]

{ #category : #loading }
ConfigurationOfOrderPreservingDictionary class >> load [
	"self load"

	^self project latestVersion load
]

{ #category : #loading }
ConfigurationOfOrderPreservingDictionary class >> loadDefault [
	"self loadDefault"

	^ self loadMostRecentCoreWithTests
]

{ #category : #loading }
ConfigurationOfOrderPreservingDictionary class >> loadMostRecentCoreWithTests [
	^self project lastVersion load: #('Core' 'Tests')
]

{ #category : #'metacello tool support' }
ConfigurationOfOrderPreservingDictionary class >> metacelloVersion: versionString loads: anArrayOrString [
	"Stash the last version loaded and the list of packages loaded for that version. The list
	 of packages will be used by the tools when doing 'Load Package Version'"

	LastVersionLoad := versionString -> anArrayOrString
]

{ #category : #accessing }
ConfigurationOfOrderPreservingDictionary class >> project [

	^self new project
]

{ #category : #'unloading Metacello' }
ConfigurationOfOrderPreservingDictionary class >> unloadMetacello [

	Smalltalk at: #ConfigurationOfMetacello ifPresent: [:cls | cls unloadMetacello ]
]

{ #category : #baselines }
ConfigurationOfOrderPreservingDictionary >> baseline100: spec [ 
	<version: '1.0-baseline'>
	
	spec for: #common do: [
		spec blessing: #baseline.
		spec repository: 'http://smalltalkhub.com/mc/Pharo/OrderPreservingDictionary/main'.	
		spec description: 'Imported from SqueakSource'.
		spec package: 'Collections-OrderPreservingDictionary'.
		spec 
			package: 'Collections-Tests-OrderPreservingDictionary' 
			with: [spec requires: 'Collections-OrderPreservingDictionary'].
			
		spec
			group: 'default' with: #('Core');
			group: 'Core' with: #('Collections-OrderPreservingDictionary');
			group: 'Tests' with: #('Collections-Tests-OrderPreservingDictionary'). ].
]

{ #category : #'symbolic versions' }
ConfigurationOfOrderPreservingDictionary >> development: spec [
	<symbolicVersion: #'development'>

	spec for: #'common' version: '1.0'

]

{ #category : #accessing }
ConfigurationOfOrderPreservingDictionary >> project [

	^ project ifNil: [ | constructor |
		"Bootstrap Metacello if it is not already loaded"
		self class ensureMetacello.
		"Construct Metacello project"
		constructor := (Smalltalk at: #MetacelloVersionConstructor) on: self.
		project := constructor project.
		project loadType: #linear. "change to #atomic if desired"
		project ]
]

{ #category : #'symbolic versions' }
ConfigurationOfOrderPreservingDictionary >> stable: spec [
	<symbolicVersion: #'stable'>

	spec for: #'common' version: '1.0'.
	
]

{ #category : #versions }
ConfigurationOfOrderPreservingDictionary >> version100: spec [ 
	<version: '1.0' imports: #('1.0-baseline') >
	
	spec for: #common do: [
		spec blessing: #release.
		spec description: 'Latest versions from Squeaksource'.
		
		spec package: 'Collections-OrderPreservingDictionary' with: 'Collections-OrderPreservingDictionary-JAA.7'.
		spec package: 'Collections-Tests-OrderPreservingDictionary' with: 'Collections-Tests-OrderPreservingDictionary-JAAyer.7'
		]
	


]