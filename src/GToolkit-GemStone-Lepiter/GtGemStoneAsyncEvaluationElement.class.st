Class {
	#name : #GtGemStoneAsyncEvaluationElement,
	#superclass : #BrVerticalPane,
	#instVars : [
		'headerElement',
		'mainContainer',
		'contentContainer',
		'titleNotifier',
		'gemStoneSessionLabel',
		'startTimeLabel',
		'elapsedTimeLabel',
		'executionStatusLabel',
		'endTimeLabel',
		'durationLabel',
		'startTimeSeparatorLabel',
		'headerToolbarElement',
		'executionToolbarElement',
		'headerToolbarUpdater',
		'executionContentUpdater',
		'promiseResolution',
		'replacePaneContentAutomatically'
	],
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #callbacks }
GtGemStoneAsyncEvaluationElement >> actOnPromiseExecutionCompleted [
	self requestUpdateOrReplaceContent.
]

{ #category : #callbacks }
GtGemStoneAsyncEvaluationElement >> actOnPromiseExecutionStarted [
	self requestMainContainerAndToolbarUpdate
]

{ #category : #'building widgets' }
GtGemStoneAsyncEvaluationElement >> buildDetailsContainerElement [
	^ (BrVerticalPane new)
		hFitContent;
		vFitContent;
		border: (BlBorder paint: Color gray);
		geometry: (BlRoundedRectangleGeometry cornerRadius: 10);
		padding: (BlInsets all: 15);
		addChild: self buildExecutionStatusRow;
		addChild: self buildStartTimeRow;
		addChild: self buildEndTimeRow;
		addChild: self buildDurationRow;
		addChild: self buildGemStoneSessionRow;
		addChild:(executionToolbarElement := self buildToolbar
				margin: (BlInsets top: 10)) 
			as: #executionToolbar
]

{ #category : #'building widgets' }
GtGemStoneAsyncEvaluationElement >> buildDetailsLabelWithText: aString [ 
	^ ((BrLabel new)
			hExact: 65;
			aptitude: (BrGlamorousLabelAptitude new 
				foreground: Color gray);
			text: aString, ': ';
			margin: (BlInsets right: 5))
]

{ #category : #'building widgets' }
GtGemStoneAsyncEvaluationElement >> buildDurationRow [
	^self buildRowContainer
		addChild: (self buildDetailsLabelWithText: 'Duration');
		addChild: (durationLabel := self buildUnknownValueLabel
			text: '-')
]

{ #category : #'building widgets' }
GtGemStoneAsyncEvaluationElement >> buildEndTimeRow [
	^self buildRowContainer
		addChild: (self buildDetailsLabelWithText: 'End time');
		addChild: (endTimeLabel := self buildUnknownValueLabel
			text: '-')
]

{ #category : #'building widgets' }
GtGemStoneAsyncEvaluationElement >> buildExecutionStatusRow [
	^self buildRowContainer
		addChild: (self buildDetailsLabelWithText: 'Status');
		addChild: (executionStatusLabel := self buildUnknownValueLabel)
]

{ #category : #'building widgets' }
GtGemStoneAsyncEvaluationElement >> buildGemStoneSessionRow [
	^self buildRowContainer
		addChild: (self buildDetailsLabelWithText: 'Session');
		addChild: (gemStoneSessionLabel := self buildUnknownValueLabel)
]

{ #category : #'building widgets' }
GtGemStoneAsyncEvaluationElement >> buildHeaderElement [
	^ BrHorizontalPane new 
		alignCenter;
		clipChildren: false;
		margin: (BlInsets top: 5 left: 0 bottom: 0 right: 0);
		vFitContent;
		hMatchParent
]

{ #category : #'building widgets' }
GtGemStoneAsyncEvaluationElement >> buildRowContainer [
	^(BrHorizontalPane new)
		hFitContent;
		vFitContent
]

{ #category : #'building widgets' }
GtGemStoneAsyncEvaluationElement >> buildStartTimeRow [
	^self buildRowContainer
		addChild: (self buildDetailsLabelWithText: 'Start time');
		addChild: (startTimeLabel := self buildUnknownValueLabel
			text: '-');
		addChild: (startTimeSeparatorLabel := self buildUnknownValueLabel
			text: '');
		addChild: (elapsedTimeLabel := BrLabel new
			text: '';
			updatingDateAndTimeModel;
			aptitude: (BrGlamorousLabelAptitude new);
			yourself)
]

{ #category : #'building widgets' }
GtGemStoneAsyncEvaluationElement >> buildToolLabel [
	^(BrLabel new)
		aptitude: ((BrGlamorousLabelAptitude new)
					foreground: Color lightGray";
					labelDo: 
							[:aLabel |
							aLabel
								editorMeasurement;
								padding: BlInsets empty]");
		preventMeAndChildrenMouseEvents;
		text: self toolName;
		margin: (BlInsets
					top: 8
					left: 0
					bottom: 8
					right: 0);
		padding: (BlInsets top: 5 bottom: 5);
		hMatchParent;
		vFitContent;
		background: Color white
]

{ #category : #'building widgets' }
GtGemStoneAsyncEvaluationElement >> buildToolbar [
	^ BrToolbar new
		aptitude: BrGlamorousToolbarAptitude new;
		alignCenterLeft;
		fitContent.
]

{ #category : #'building widgets' }
GtGemStoneAsyncEvaluationElement >> buildUnknownValueLabel [
	^ (BrLabel new)
		aptitude: BrGlamorousLabelAptitude;
		text: '<uknown>'
]

{ #category : #accessing }
GtGemStoneAsyncEvaluationElement >> collectExecutionToolbarActions [ 
	^ GtPhlowActionsCollector new
		pragmaName: #gtExecutionAction;
		fromObject: self;
		collect
]

{ #category : #accessing }
GtGemStoneAsyncEvaluationElement >> collectHeaderToolbarActions [ 
	^ GtPhlowActionsCollector new
		pragmaName: #gtToolbarAction;
		fromObject: self;
		collect
]

{ #category : #'initialization ' }
GtGemStoneAsyncEvaluationElement >> createTitleNotifier [
	^ GtPhlowTitleIconAndLabelNotifier new 
		longLabel: [self toolName]
]

{ #category : #'gt - actions' }
GtGemStoneAsyncEvaluationElement >> gtActionInspectResolvedValueFor: anAction [
	<gtExecutionAction>

	self isValueResolved ifFalse: [ ^ anAction empty ].
	
	^ anAction button
		label: 'Result';
		priority: 105;
		icon: BrGlamorousVectorIcons inspect;
		tooltip: 'Inspect Result';
		action: [ :button |
			button phlow spawnObject: promiseResolution resolvedValue  ].
]

{ #category : #'gt - actions' }
GtGemStoneAsyncEvaluationElement >> gtActionInspectSessionFor: anAction [
	<gtToolbarAction>

	promiseResolution ifNil: [ ^ anAction empty ].
	
	^ anAction button
		label: 'GS';
		priority: 105;
		icon: BrGlamorousVectorIcons inspect;
		tooltip: 'Inspect GemStone Session';
		action: [ :button |
			button phlow spawnObject: promiseResolution gemStoneSession  ].
]

{ #category : #'gt - actions' }
GtGemStoneAsyncEvaluationElement >> gtActionToggleAutomaticReplaceFor: anAction [
	<gtToolbarAction>
	
	^ anAction button
		label: (self replacePaneContentAutomatically
			ifTrue: [ 'Disable' ]
			ifFalse: [ 'Enable' ]);
		priority: 150;
		icon: BrGlamorousIcons spawn;
		tooltip: (self replacePaneContentAutomatically
			ifTrue: [ 'Disable automatic replacement of content when execution terminates ' ]
			ifFalse: [ 'Enable automatic replacement of content when execution terminates '  ]);
		action: [ :button |
			self toggleReplacePaneContentAutomatically.
			self updateHeaderToolbarActions.  ].
]

{ #category : #'gt - actions' }
GtGemStoneAsyncEvaluationElement >> gtActionUpdateDetailsFor: anAction [
	<gtToolbarAction>
	
	^ anAction button
		tooltip: 'Refresh';
		priority: 10;
		icon: BrGlamorousIcons refresh;
		action: [ 
			self requestUpdate ]
]

{ #category : #'initialization ' }
GtGemStoneAsyncEvaluationElement >> initialize [
	super initialize.
	
	self matchParent.
	self padding: (BlInsets all: 5).
	
	self initializeHeaderElement.
	self initializeMainContainerElement.
	
	self addChild: headerElement as: #header.
	self addChild: mainContainer as: #mainContainer.
	
	self initializeTitleNotifier.
	self initializeUpdaters.
	
	self updateHeaderToolbarActions.
]

{ #category : #'initialization ' }
GtGemStoneAsyncEvaluationElement >> initializeHeaderElement [
	headerElement := self buildHeaderElement.
	headerToolbarElement := self buildToolbar.

	headerElement addChild: self buildToolLabel as: #toolLabel.
	headerElement addChild: headerToolbarElement as: #headerToolbar.
]

{ #category : #'initialization ' }
GtGemStoneAsyncEvaluationElement >> initializeMainContainerElement [

	mainContainer := BrVerticalPane new 
		hMatchParent;
		vFitContent;
		alignTopCenter;
		margin: (BlInsets top: 25).
	
	mainContainer addChild: self buildDetailsContainerElement.
	"mainContainer addChild: (contentContainer := self buildContentContainerElement)."
	"contentContainer margin: (BlInsets top: 15)."
]

{ #category : #'initialization ' }
GtGemStoneAsyncEvaluationElement >> initializeTitleNotifier [
	titleNotifier := self createTitleNotifier.
	self addEventHandler: titleNotifier
]

{ #category : #'initialization ' }
GtGemStoneAsyncEvaluationElement >> initializeUpdaters [
	headerToolbarUpdater := BrElementUpdater new 
		element: self
		selector: #updateHeaderToolbarActions.
	
	executionContentUpdater := BrElementUpdater new 
		element: self
		selector: #updateExecutionContent.
]

{ #category : #testing }
GtGemStoneAsyncEvaluationElement >> isValueResolved [
	^ promiseResolution isNotNil and: [
		promiseResolution isValueResolved  ]
]

{ #category : #callbacks }
GtGemStoneAsyncEvaluationElement >> onSnippetPromiseResolutionChanged [
	self updateMainContainerAndToolbar.
	self requestUpdateOrReplaceContent
]

{ #category : #querying }
GtGemStoneAsyncEvaluationElement >> previousPagerPageElementDo: aBlock [
	self 
		allParentsDetect: [ :anElement | anElement class = GtPagerPageElement ] 
		ifFound: [ :aPageElement | 
			aPageElement previousSiblingDo: aBlock ]
		ifNone: [ "do nothing" ]
]

{ #category : #accessing }
GtGemStoneAsyncEvaluationElement >> promiseResolution: aGtGemStonePromiseExecution [
	promiseResolution == aGtGemStonePromiseExecution 
		ifTrue: [ ^ self ].

	promiseResolution ifNotNil: [ self unsubscribeFromPromiseResolution ].

	promiseResolution := aGtGemStonePromiseExecution.
	
	self onSnippetPromiseResolutionChanged.
	self subscribeToPromiseResolution.
]

{ #category : #accessing }
GtGemStoneAsyncEvaluationElement >> replacePaneContentAutomatically [
	^ GtGemStoneAsyncEvaluationPhlowTool replacePaneContentAutomatically
]

{ #category : #accessing }
GtGemStoneAsyncEvaluationElement >> replacePaneContentAutomatically: aBoolean [
	GtGemStoneAsyncEvaluationPhlowTool replacePaneContentAutomatically: aBoolean
]

{ #category : #updating }
GtGemStoneAsyncEvaluationElement >> replaceToolWithResultIfNotPossible: aBlock [
	self replacePaneContentAutomatically ifFalse: [
		aBlock value.
		^ self ].
	self isValueResolved ifFalse: [
		aBlock value.
		^ self ].

	self previousPagerPageElementDo: [ :aPageElement |
		(aPageElement 
			childWithId: #toolArea 
			ifFound: [ :anElement |
				anElement phlow 
					spawnObject: promiseResolution resolvedValue.
				^ self]) ].
	
	"We get here if we did not find a page element"
	aBlock value.
]

{ #category : #updating }
GtGemStoneAsyncEvaluationElement >> requestExecutionContentUpdate [
	executionContentUpdater requestUpdate
]

{ #category : #updating }
GtGemStoneAsyncEvaluationElement >> requestHeaderToolbarUpdate [
	headerToolbarUpdater requestUpdate
]

{ #category : #updating }
GtGemStoneAsyncEvaluationElement >> requestMainContainerAndToolbarUpdate [
	self requestHeaderToolbarUpdate.
	self requestExecutionContentUpdate.
]

{ #category : #updating }
GtGemStoneAsyncEvaluationElement >> requestUpdateOrReplaceContent [
	self enqueueTask: (BlTaskAction new 
		action: [ self updateOrReplaceContent  ]) 
]

{ #category : #accessing }
GtGemStoneAsyncEvaluationElement >> snippetPromise [
	^ promiseResolution 
		ifNil: [nil]
		ifNotNil: [ :aPromiseExecution |
			aPromiseExecution snippetPromise ]
]

{ #category : #accessing }
GtGemStoneAsyncEvaluationElement >> snippetPromise: aGtGemStoneSnippetPromise [
	self snippetPromise == aGtGemStoneSnippetPromise 
		ifTrue: [ ^ self ].

	self promiseResolution: (GtGemStoneSnippetPromiseResolution new 
		 snippetPromise: aGtGemStoneSnippetPromise).
]

{ #category : #subscriptions }
GtGemStoneAsyncEvaluationElement >> subscribeToPromiseResolution [
	promiseResolution announcer weak
		when: GtGemStoneSnippetPromiseResolutionStartedAnnouncement
		send: #actOnPromiseExecutionStarted
		to: self.
	promiseResolution announcer weak
		when: GtGemStoneSnippetPromiseResolutionCompletedAnnouncement
		send: #actOnPromiseExecutionCompleted
		to: self.
]

{ #category : #settings }
GtGemStoneAsyncEvaluationElement >> toggleReplacePaneContentAutomatically [
	self replacePaneContentAutomatically: self replacePaneContentAutomatically not 
]

{ #category : #accessing }
GtGemStoneAsyncEvaluationElement >> toolName [
	^ 'Async GemStone Execution'
]

{ #category : #subscriptions }
GtGemStoneAsyncEvaluationElement >> unsubscribeFromPromiseResolution [
	promiseResolution announcer unsubscribe: self
]

{ #category : #updating }
GtGemStoneAsyncEvaluationElement >> updateDetailsForCompletedPromise [
	gemStoneSessionLabel text: promiseResolution sessionDescription.
	executionStatusLabel text: promiseResolution state.
	startTimeSeparatorLabel text: ''.
	
	startTimeLabel text: promiseResolution startTimestamp  asTime print24.
	endTimeLabel text: promiseResolution endTimestamp  asTime print24.
	durationLabel text: promiseResolution duration gtHumanReadableString.
		
	elapsedTimeLabel updatingDateAndTimeModel stopUpdateTask.
	elapsedTimeLabel text: ''.
]

{ #category : #updating }
GtGemStoneAsyncEvaluationElement >> updateDetailsForExecutingPromise [
	executionStatusLabel text: promiseResolution state.
	startTimeSeparatorLabel text: ' - '.
	
	gemStoneSessionLabel text: promiseResolution sessionDescription.
	
	startTimeLabel text: promiseResolution startTimestamp asTime print24.
	elapsedTimeLabel updatingDateAndTime: promiseResolution startTimestamp.
]

{ #category : #updating }
GtGemStoneAsyncEvaluationElement >> updateDetailsForPendingResolution [
	executionStatusLabel text: promiseResolution state.
	gemStoneSessionLabel text: promiseResolution sessionDescription.
	
	promiseResolution startTimestamp ifNotNil: [ :aTimestamp | 
		startTimeLabel text: aTimestamp asTime print24.
		elapsedTimeLabel updatingDateAndTime: aTimestamp ].
]

{ #category : #updating }
GtGemStoneAsyncEvaluationElement >> updateExecutionContent [
	self updateExecutionDetails.
	self updateExecutionToolbarActions.
]

{ #category : #updating }
GtGemStoneAsyncEvaluationElement >> updateExecutionDetails [
	promiseResolution isResolvingCompleted
		ifTrue: [ ^ self updateDetailsForCompletedPromise ].
	promiseResolution isResolvingRunning
		ifTrue: [ ^ self updateDetailsForExecutingPromise ].
	
	self updateDetailsForPendingResolution
]

{ #category : #updating }
GtGemStoneAsyncEvaluationElement >> updateExecutionToolbarActions [
	executionToolbarElement removeAllItems.
	
	self collectExecutionToolbarActions do: [ :aPhlowAction | 
		aPhlowAction asElement: [ :actionElement | 
			executionToolbarElement 
				addItem: actionElement ]
				withHostElement: self ] 
]

{ #category : #updating }
GtGemStoneAsyncEvaluationElement >> updateHeaderToolbarActions [
	headerToolbarElement removeAllItems.
	
	self collectHeaderToolbarActions do: [ :aPhlowAction | 
		aPhlowAction asElement: [ :actionElement | 
			headerToolbarElement 
				addItem: actionElement ]
				withHostElement: self ] 
]

{ #category : #updating }
GtGemStoneAsyncEvaluationElement >> updateMainContainerAndToolbar [
	self updateHeaderToolbarActions.
	self updateExecutionContent.
]

{ #category : #updating }
GtGemStoneAsyncEvaluationElement >> updateOrReplaceContent [
	self replaceToolWithResultIfNotPossible: [
		self updateMainContainerAndToolbar ] 
]