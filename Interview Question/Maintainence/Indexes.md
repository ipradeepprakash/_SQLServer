# Index Rebuild & Reorg


## Index Rebuild
### 1. Does rebuild index cause blockings?
#### Online rebuild

    Yes, only during the final phase of index rebuild.
    Online rebuild index will hold locks(schema-Modification LCK_M) at the last stages (initial stage,intermediate stage & final stage)
    Once the rebuild reaches the last stage, nobody can access the object/table that is being rebuild on index.

#### Offline Rebuild
Locks (LCK_M) will be held for the majority of the time during rebuild.

## Index Reorg
### 1. Does Reorg index cause blockings?
		No (but will cause blocking for short time with Intent-exclusive table lock)
    
### 2. Can we consider Log shipping as reporting solution?
        - Yes, but there will be delay while log backups restore. user connections will get killed, so user will have to connect again. lengthy reports are not suitable for log shipping.
