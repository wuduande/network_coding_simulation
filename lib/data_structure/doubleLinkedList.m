classdef doubleLinkedList < handle%小于符号是继承的意思
   properties (GetAccess = private, SetAccess = private)
      count = 0;
      current = [];
      currentpos = 0;%以0为indx
   end
   methods
       function list = doubleLinkedList()
           
       end
       
       function SetPosition(list, p)
           if (p < 0 || p >= list.count)
               error('In SetPosition: Attempt to set a position not in the list.');
           elseif(list.currentpos < p )
               while( list.currentpos ~= p)
                    list.currentpos = list.currentpos + 1;
                    list.current = list.current.Next;
               end
           elseif(list.currentpos > p)
               while( list.currentpos ~= p)
                   list.currentpos = list.currentpos - 1;
                   list.current = list.current.Prev;
               end
           end
       end
       
       function ListInsert(list, anything)
            ListInsertAt(list, list.currentpos, dlnode(anything));
       end    
       
       function ListInsertAt(list, p, dlnode)
           if (p < 0 || p > list.count)
               error('In InsertList: Attempt to set a position not in the list.');
           else
               if( list.count == 0)
                   list.current = dlnode;
                   list.currentpos = 0;
               elseif( p == list.count)
                   SetPosition(list, p-1);
                   insertAfter(dlnode, list.current)
               else
                   SetPosition(list, p);
                   insertBefore(dlnode, list.current);
               end
               list.current = dlnode;
               list.currentpos = p;
               list.count = list.count + 1;
           end
       end    
          
       function ListClear(list)
           list.count = 0;
           list.current = [];
           list.currentpos = 0;
       end
       
       function isEmpty = ListEmpty(list)
           isEmpty = (list.count == 0);
       end

       function size = ListSize(list)
           size = list.count;
       end
       
       function isFull = ListFull(list)
           isFull = 0;
       end
       
       function data = ListGet(list, p)
           SetPosition(list, p);
           data = list.current.Data;
       end
       
       function output = ListRemove(list, p)
           SetPosition(list, p);
           aNode = list.current;
           toBeDeleted = list.current;
           if(list.count == 1)
                list.currentpos = 0;
                list.current = [];
           elseif( list.count-1 == p)
               list.current = list.current.Prev;
               list.currentpos = list.currentpos - 1;
           else
                list.current = list.current.Next;
           end
           disconnect(toBeDeleted);
           list.count = list.count - 1;
           
           output = aNode.Data;
       end
       
       function aNode = ListReplace(list, p, dlnode)
           SetPosition(list, p);
           toBeReplaced = list.current;
           insertBefore(dlnode, list.current);
           list.current = dlnode;
           disconnect(toBeReplaced);
           aNode = toBeReplaced;
       end
       
       function position = FindFirstInList(list, func)
           found = 0;
           for i = 0:list.count - 1
               SetPosition(list, i);
               if( func(list.current))
                   found = 1;
                   position = i;
                   break;
               end               
           end
           if( found == 0)
               position = list.count;
           end
       end
       
       function ListTraverse(list, func)
           for i = 0:list.count - 1
               aNode = ListGet(list, i);
               func(aNode);
           end
       end
       
       function ListDisp(list)
           bound = list.count;
           for indx=0:bound-1
               aNode = ListGet(list, indx);
               display(aNode);
           end
       end
   end % methods
   
end % classdef