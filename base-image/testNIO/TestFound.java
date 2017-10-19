
import java.util.List;
import java.util.* ;
import java.util.concurrent.atomic.*;
import java.util.concurrent.ConcurrentHashMap ;
/**
 * Created by shawn on 2017/10/19.
 
 * test 轮询算法
    test  lambda 
 */
public class TestRound {


    public static void main(String[] args) {

        List<String>  nodelist =  new ArrayList<String>() ;

        nodelist.add("10.2.33.10");
        nodelist.add("10.2.33.11");
        nodelist.add("10.2.33.12");
        nodelist.add("10.2.33.14");
//        nodelist.forEach(n->System.out.println(n));

//        nodelist.forEach(System.out::println);

        Map<String,Integer>  m = new ConcurrentHashMap<String, Integer>();

        AtomicInteger  count =  new AtomicInteger(1) ;
        //System.err.println(count);
        int test = 12  ;
        for(int i=1;i<=test;i++){
            int index = count.getAndIncrement() % nodelist.size() ;

             if(m.containsKey(nodelist.get(index))){
                 m.put(nodelist.get(index),m.get(nodelist.get(index)) + 1 );
             }else{
                 m.put(nodelist.get(index),1) ;
             }

            System.err.println("request will to " + nodelist.get(index)) ;
        }

        m.forEach((k,v)->System.out.println("node " + k + " access count [ " + v + " ]"));


        // lambda test
//
//        new Thread(){
//            {
//                int a = 1 ;
//                while(a <5 ){
//                    System.out.println("test");
//                    a+=1 ;
//                }
//            }
//        }.start();


    }
