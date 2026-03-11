/* REXX */                                                              
                                                                        
/* DESCRIÇÃO: */                                                        
/* Le membros a partir da saida do LISTDS, abre cada membro,            
   busca GRVTM nas colunas 2 a 6 ou a informação no intervalo de        
   (INCLUDE-PARM-FUN/END-INCLUDE) e (EXCLUDE-PARM-FUN/END-EXCLUDE)      
   e grava na saida */                                                  
                                                                        
CALL Inicio                                                             
CALL AlocaOutput                                                        
CALL AlocaListaMembros                                                  
CALL IdentificaMembro                                                   
CALL Encerra                                                            
                                                                        
EXIT 0                                                                  
                                                                        
Inicio:                                                                 
   PDS   = "PRINC.LIB.SOURCE"                                            
   LIST  = USERID() || ".MEMS.LIST"                                     
   OUTDS = USERID() || ".GRVT.RESULT"                                   
Return                                                                  
                                                                        
AlocaOutput:                                                            
   /* Alloca Output */                                                  
   ADDRESS TSO                                                          
   "FREE FI(OUTDD)"                                                     
   "DELETE '"OUTDS"'"     /* Deleta PSD se ja existir */                
   "ALLOC F(OUTDD) DA('"OUTDS"') NEW CATALOG ",                         
          "RECFM(F B) LRECL(80) BLKSIZE(0) SPACE(10,100) CYL"           
                                                                        
   /* Prepara buffer de saida*/                                         
   OUT. = ""                                                            
Return                                                                  
                                                                        
AlocaListaMembros:                                                      
   /* Ler lista de Membros */                                           
   "ALLOC F(IN) DA('"LIST"') SHR"                                       
   "EXECIO * DISKR IN (STEM L. FINIS"                                   
   "FREE F(IN)"                                                         
Return                                                                  
                                                                        
IdentificaMembro:                                                       
   PARSEFLAG = 0 /* Começa a ler só após --MEMBERS-- */                 
   FIRSTEXEC = 0 /* Na primeira execução não grava 2 espaços */         
                                                                        
   DO I = 1 TO L.0                                                      
      LINE = STRIP(L.I)                                                 
                                                                        
      /* Ativa a flag de leitura ao encontrar --MEMBERS-- */            
      IF LINE = "--MEMBERS--" THEN DO                                   
          PARSEFLAG = 1                                                 
          ITERATE                                                       
      END                                                               
                                                                        
      /* Desativa a flag ao encontrar Ready ou End */                   
      IF LINE = "READY" | LINE = "END" THEN DO                          
          PARSEFLAG = 0                                                 
          ITERATE                                                       
      END                                                               
                                                                        
      /* Ignora linhas antes da seção de membros */                     
      IF PARSEFLAG = 0 THEN ITERATE                                     
      IF LINE = "" THEN ITERATE                                         
                                                                        
      /* Atribui membro lido à MEMBER */                                
      MEMBER = STRIP(LINE)                                              
                                                                        
      /* Monta o DSN completo */                                        
      FULL = PDS"("MEMBER")"                                            
                                                                        
      CALL LeMembro                                                     
      CALL ProcessaLinha                                                
      CALL GravaSaida                                                   
   END                                                                  
Return                                                                  
                                                                        
LeMembro:                                                               
   /* Ler o Membro Completo */                                          
   ADDRESS TSO                                                          
   "ALLOC F(M) DA('"FULL"') SHR REUSE"                                  
   "EXECIO * DISKR M (STEM LINHA. FINIS"                                
   "FREE FI(M)"                                                         
Return                                                                  
                                                                        
ProcessaLinha:                                                          
   /* Prepara buffer */                                                 
   OUTCOUNT = 0 /* Contador de linhas para serem gravadas */            
   LINHAFLAG = 0 /* Permite grava a linha quando igual a 1 */           
   GRVMEMBER = 0 /* Gravar nome do membro */                            
                                                                        
   /* Analise dentro de cada linha */                                   
   DO J = 1 TO LINHA.0                                                  
      /* Ativa flag de linha ao encontrar EXCLUDE-PARM-FUN */           
      IF (POS("INCLUDE-PARM-FUN",LINHA.J) > 0) |,                       
         (POS("EXCLUDE-PARM-FUN",LINHA.J) > 0) THEN                     
         LINHAFLAG = 1                                                  
                                                                        
      /* Desativa flag de linha ao encontrar EXCLUDE-PARM-FUN */        
      IF (POS("END-INCLUDE",LINHA.J) > 0) |,                            
         (POS("END-EXCLUDE",LINHA.J) > 0) THEN                          
         LINHAFLAG = 0                                                  
                                                                        
      /* Adiciona à saida se tiver GRVTM nas linhas 2 a 6 ou            
         se a flag de linha estiver ativada */                          
      GRVTM = UPPER(SUBSTR(LINHA.J,2,5))                                
      IF GRVTM = "GRVTM" | LINHAFLAG = 1 THEN DO                        
         IF GRVMEMBER = 0 THEN DO                                       
            /* Grava 2 espaços após a primeira gravação de membro */    
            IF FIRSTEXEC = 1 THEN DO                                    
               OUTCOUNT = OUTCOUNT + 1                                  
               OUT.OUTCOUNT = ""                                        
               OUTCOUNT = OUTCOUNT + 1                                  
               OUT.OUTCOUNT = ""                                        
            END                                                         
                                                                        
            /* Grava nome do membro e depois um espaço */               
            OUTCOUNT = OUTCOUNT + 1                                     
            OUT.OUTCOUNT = "PROGRAMA - " || MEMBER                      
            OUTCOUNT = OUTCOUNT + 1                                     
            OUT.OUTCOUNT = ""                                           
            GRVMEMBER = 1                                               
         END                                                            
         OUTCOUNT = OUTCOUNT + 1                                        
         OUT.OUTCOUNT = LINHA.J                                         
      END                                                               
   END                                                                  
Return                                                                  
                                                                        
GravaSaida:                                                             
   /* Grava saída após terminar o processamento de cada membro */       
   IF OUTCOUNT > 0 THEN DO                                              
                                                                        
      ADDRESS TSO "EXECIO "OUTCOUNT" DISKW OUTDD (STEM OUT.)"           
                                                                        
      /* Ativa 2 espaços após cada gravação de membro */                
      FIRSTEXEC = 1                                                     
   END                                                                  
Return                                                                  
                                                                        
Encerra:                                                                
   "FREE FI(OUTDD)"                                                     
   SAY "PROCESSAMENTO CONCLUIDO."                                       
Return                                                                  
