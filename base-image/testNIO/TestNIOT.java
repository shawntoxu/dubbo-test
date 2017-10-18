
import java.io.IOException;
import java.net.InetSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.SelectionKey;
import java.nio.channels.Selector;
import java.nio.channels.ServerSocketChannel;
import java.nio.channels.SocketChannel;
import java.util.Iterator;

/**
 * Created by shawn on 2017/10/18.
 */
public class TestNIO {
    public Selector  selector  ;

    public void startServer(int port) throws java.lang.Exception{
        ServerSocketChannel scc = ServerSocketChannel.open();
        scc.bind(new InetSocketAddress(port)) ;
        scc.configureBlocking(false) ;
        this.selector = Selector.open() ;
        scc.register(selector, SelectionKey.OP_ACCEPT) ;

        System.out.println(" server is ok .");


        listenCient();
    }

    public  void listenCient() throws java.lang.Exception {

    while(true) { // always  linster client connection

            try {
                this.selector.select();
            } catch (IOException e) {
                e.printStackTrace();
            }
            Iterator<SelectionKey> it = selector.selectedKeys().iterator();
            while (it.hasNext()) {
                SelectionKey key = it.next();
                it.remove();
                handleClient(key);

            }

        }
    }

    private void handleClient(SelectionKey key) throws java.lang.Exception {
        if(key.isAcceptable()){
            System.out.println("a client coming .") ;
            ServerSocketChannel  scc  =  (ServerSocketChannel) key.channel();
            SocketChannel client = scc.accept() ;
            if(null !=  client) {
                client.configureBlocking(false);
                client.register(this.selector, SelectionKey.OP_READ);
            }
        }else if(key.isReadable()){
            SocketChannel schannel  = (SocketChannel)key.channel();
            String address  = schannel.getRemoteAddress().toString() ;
            ByteBuffer  buf  = ByteBuffer.allocate(1024);
            int rdata = schannel.read(buf);
            if(rdata > 0 ){
                String data = new String(buf.array(),"UTF-8");
                if(null != data && data.trim().equals("bye")){
                    System.err.println(address + " client say bye .");
                    schannel.close();
                }else{
                    System.err.println(address+" send :[ "+data+" ]");
                }
            }else{
                key.cancel();
                System.out.println(" a client  is gone away .");
            }

        }

    }

    public static void main(String[] args) throws java.lang.Exception {

        TestNIO tt = new TestNIO();
        tt.startServer(9999);
        tt.listenCient();

    }
}
