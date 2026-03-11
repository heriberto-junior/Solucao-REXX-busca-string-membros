//VRFGRVTM JOB CLASS=L,MSGCLASS=X,NOTIFY=&SYSUID,                  
//             REGION=2M,TIME=500                                  
//*            REGION=2M,TIME=500,RESTART=LISTMEMP                 
//*---------------------------------------------------------------*
//LISTPDS  EXEC PGM=IKJEFT01                                       
//SYSTSPRT DD  DSN=&SYSUID..MEMS.LIST,                             
//         DISP=(OLD,CATLG,DELETE),                                
//         RECFM=FB,LRECL=80,BLKSIZE=0,                            
//         SPACE=(TRK,(1,1),RLSE)                                  
//SYSTSIN  DD  *                                                   
  LISTDS 'PRINC.LIB.SOURCE' MEMBERS                                 
/*                                                                 
//*---------------------------------------------------------------*
//LISTMEMP EXEC PGM=IKJEFT01,PARM='LISTMEMB'                       
//SYSPROC  DD DSN=LIBPRINC.LIB.REXX,DISP=SHR                        
//SYSTSPRT DD SYSOUT=*                                             
//SYSPRINT DD SYSOUT=*                                             
//SYSTSIN  DD DUMMY                                                
