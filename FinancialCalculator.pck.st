'From Cuis7.1 [latest update: #6472] on 24 June 2024 at 3:36:38 pm'!
'Description '!
!provides: 'FinancialCalculator' 1 12!
SystemOrganization addCategory: #'FinancialCalculator-Tests'!
SystemOrganization addCategory: #FinancialCalculator!


!classDefinition: #TVM category: #FinancialCalculator!
Object subclass: #TVM
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'FinancialCalculator'!
!classDefinition: 'TVM class' category: #FinancialCalculator!
TVM class
	instanceVariableNames: ''!

!classDefinition: #Annuity category: #FinancialCalculator!
TVM subclass: #Annuity
	instanceVariableNames: 'A n g'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'FinancialCalculator'!
!classDefinition: 'Annuity class' category: #FinancialCalculator!
Annuity class
	instanceVariableNames: ''!

!classDefinition: #TVMPresent category: #FinancialCalculator!
TVM subclass: #TVMPresent
	instanceVariableNames: 'money'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'FinancialCalculator'!
!classDefinition: 'TVMPresent class' category: #FinancialCalculator!
TVMPresent class
	instanceVariableNames: ''!

!classDefinition: #TVMShifted category: #FinancialCalculator!
TVM subclass: #TVMShifted
	instanceVariableNames: 'tvm periodShift interestRate'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'FinancialCalculator'!
!classDefinition: 'TVMShifted class' category: #FinancialCalculator!
TVMShifted class
	instanceVariableNames: ''!


!TVM methodsFor: 'tvm' stamp: 'nafiz 6/24/2024 14:09:32'!
allAtPeriod: aPeriod interestRate: aInterestRate

	self subclassResponsibility! !

!TVM methodsFor: 'tvm' stamp: 'nafiz 6/24/2024 12:48:13'!
atPeriod: aPeriod
	self subclassResponsibility ! !

!TVM methodsFor: 'tvm' stamp: 'nafiz 6/24/2024 14:11:58'!
moneyAtPeriod: aPeriod interestRate: aInterestRate
^ (self allAtPeriod: aPeriod interestRate: aInterestRate) money! !

!Annuity methodsFor: 'tvm' stamp: 'nafiz 6/24/2024 14:46:21'!
allAtPeriod: aPeriod interestRate: aInterestRate
	^ (TVMPresent money: (self growingAnnuityAtInterestRate: aInterestRate)) allAtPeriod: aPeriod interestRate: aInterestRate! !

!Annuity methodsFor: 'tvm' stamp: 'nafiz 6/24/2024 14:27:27'!
atPeriod: aPeriod
	^ TVMPresent
		money: (aPeriod <= n ifTrue: (A * (1 + g) * aPeriod) ifFalse: 0)
		period: aPeriod.! !

!Annuity methodsFor: 'private' stamp: 'nafiz 6/24/2024 14:45:57'!
growingAnnuityAtInterestRate: aInterestRate

	^ A / (aInterestRate - g) * (1 - (1 + g / (1 + aInterestRate)) ^ n)! !

!TVMPresent methodsFor: 'private' stamp: 'nafiz 6/22/2024 10:55:50'!
setMoney: aMoney
money := aMoney! !

!TVMPresent methodsFor: 'tvm' stamp: 'nafiz 6/24/2024 14:49:26'!
allAtPeriod: aPeriod interestRate: aInterestRate
	^ TVMPresent
		money:
			money *
				(aInterestRate zero
					ifTrue: [ 1 ]
					ifFalse: [ 1 + aInterestRate raisedTo: aPeriod ])
		period: aPeriod.! !

!TVMPresent methodsFor: 'tvm' stamp: 'nafiz 6/24/2024 14:10:23'!
atPeriod: aPeriod
	aPeriod zero
		ifTrue: [ ^ self ]
		ifFalse: [ ^ TVMPresent money: 0 period: aPeriod ].! !

!TVMPresent methodsFor: 'tvm' stamp: 'nafiz 6/24/2024 13:42:34'!
money
^ money! !

!TVMPresent class methodsFor: 'instance creation' stamp: 'nafiz 6/24/2024 13:47:29'!
money: aMoney
	^ self new setMoney: aMoney.! !

!TVMPresent class methodsFor: 'instance creation' stamp: 'nafiz 6/24/2024 14:18:14'!
money: aMoney period: aPeriod
	^ TVMShifted 		tvm: (self new setMoney: aMoney) periodShift: aPeriod! !

!TVMShifted methodsFor: 'tvm' stamp: 'nafiz 6/24/2024 14:34:10'!
allAtPeriod: aPeriod interestRate: aInterestRate
	| newTVM |
	newTVM := tvm
		allAtPeriod: periodShift
		interestRate: interestRate.
	newTVM := newTVM
		allAtPeriod: aPeriod - periodShift
		interestRate: aInterestRate.
	^ newTVM.! !

!TVMShifted methodsFor: 'tvm' stamp: 'nafiz 6/24/2024 12:37:33'!
atPeriod: aPeriod
	^ tvm atPeriod: aPeriod - periodShift.! !

!TVMShifted methodsFor: 'tvm' stamp: 'nafiz 6/24/2024 13:52:36'!
money
	^ tvm money.! !

!TVMShifted methodsFor: 'private' stamp: 'nafiz 6/24/2024 12:40:27'!
setInterestRate: aInterestRate
interestRate := aInterestRate! !

!TVMShifted methodsFor: 'private' stamp: 'nafiz 6/24/2024 12:29:06'!
setPeriodShift: aPeriodShift
periodShift := aPeriodShift! !

!TVMShifted methodsFor: 'private' stamp: 'nafiz 6/24/2024 12:30:56'!
setTVM: aTVM
tvm := aTVM! !

!TVMShifted class methodsFor: 'as yet unclassified' stamp: 'nafiz 6/24/2024 13:45:46'!
tvm: aTVM periodShift: aPeriodShift
	^ self
		tvm: aTVM
		periodShift: aPeriodShift
		interestRate: 0.! !

!TVMShifted class methodsFor: 'as yet unclassified' stamp: 'nafiz 6/24/2024 13:46:05'!
tvm: aTVM periodShift: aPeriodShift interestRate: aInterestRate
^ self new 
		setTVM: aTVM;
		setPeriodShift: aPeriodShift;
		setInterestRate: aInterestRate.! !

!Number methodsFor: '*FinancialCalculator' stamp: 'nafiz 6/22/2024 12:40:10'!
percent
^ self / 100! !
