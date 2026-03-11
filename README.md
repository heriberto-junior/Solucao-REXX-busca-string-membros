# Solucao-REXX-busca-string-membros
Solução em REXX e JCL que busca determinadas strings dentro de todos os membros de um particionada e adiciona em um arquivo de saída

Nessa solução o JCL gera em seu primeiro step uma lista com todos os particionados com a seguinte estrutura:

```
READY                             
  LISTDS 'PRINC.LIB.SOURCE' MEMBERS
PRINC.LIB.SOURCE                   
--RECFM-LRECL-BLKSIZE-DSORG       
  FB    80    27920   PO          
                                  
--VOLUMES--                       
  INTT03                          
--MEMBERS--                       
  ABCARTEP                        
  ABCC0506                        
  ABCC0507                        
  ABCDI900                        
  ABCDI901                        
  ABCFF005                        
  ...
READY
END
```
