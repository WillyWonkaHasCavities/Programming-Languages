import java.applet.*;
import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

// The handshake is reliable now.  Girl pings Boy, gets confirmation.
// Then Boy pings girl, get confirmation.
class MonitorFixed {
   String name;
   DFrameFixed df;
   boolean waiting;

   public MonitorFixed (DFrameFixed d, String name) { 
      df = d; 
      this.name = name; 
   }

   public String getName() {  return this.name; }

   // The Girl and Boy invoke their ping.  One of the two reaches 
   // p.release(p) first but since the other thread has not even 
   // entered its ping, no thread is released.  The first thread 
   // continues to the try-catch and waits before invoking p.confirm().
   // This allows the other thread to enter its ping.  That thread 
   // wakes up the first thread by invoking p.release(p).  It then 
   // continues to the try-catch block and waits.  Since the first 
   // thread is now awake, it gets run time and invokes p.confirm().
   // Since the 'other' (that is, 'p') thread is waiting, the first 
   // thread enters the 'p' thread's monitor and invokes the confirm.  
   // The confirm returns and the first thread continues to p.release(p).  
   // The other thread awakens and continues to p.confirm().  Since 
   // there is no thread that owns the first thread's monitor, confirm 
   // completes and the other thread continues to p.release() where 
   // nothing happens and the handshake ends.
   public synchronized void ping (MonitorFixed p) {
      String nm = p.getName();
      String me = this.name;
      p.release(p);
      
      df.area.append("   " + me + " (ping): wait to ask to confirm\n");

      try { wait(); } catch (Exception e) { }

      df.area.append(me + " (ping): asking " + nm + " to confirm\n");
      p.confirm(this);

      df.area.append(me + " (ping): got confirmation\n");
      p.release(p);
   }

   public synchronized void confirm (MonitorFixed p) {
      df.area.append(this.name+" (confirm): confirm to "+p.getName()+"\n");
   }

   public synchronized void release (MonitorFixed p) { 
      message(p.getName(), name);
      notify(); 
   }

   public void message(String n1, String n2) {
      if (waiting)
	 df.area.append("   "+n1+": "+n2+" released\n");
      else
	 df.area.append("   "+n1+": no "+n2+" to release\n");
   }
}

class RunnerFixed extends Thread {
   MonitorFixed m1, m2;
   DFrameFixed f;

   public RunnerFixed (MonitorFixed m1, MonitorFixed m2, DFrameFixed f) { 
      this.f = f;
      this.m1 = m1; 
      this.m2 = m2; 
   }

   public void run () {
      f.area.append("Invoke ping of "+m1.getName()+"\n");
      m1.ping(m2);  
   }
}

class DFrameFixed extends JFrame implements ActionListener, Runnable {
   JButton go;
   JTextArea area;
   int i = 1;
   Thread runner;
   JComboBox <String> delay;
   
   public DFrameFixed () {
      setLayout(new BorderLayout());
      add("Center", new JScrollPane(area = new JTextArea()));
      JPanel p = new JPanel();
      p.setLayout(new FlowLayout());
      p.add(new JLabel("Delay:", JLabel.RIGHT));
      p.add(delay = new JComboBox <String> ());
      delay.addItem("No");
      delay.addItem("Yes");
      p.add(new JLabel("      "));
      p.add(go = new JButton("Start"));
      add("South", p);
      go.addActionListener(this);
      area.setFont(new Font("TimesRoman", Font.PLAIN, 20));
   }

   public void actionPerformed (ActionEvent evt) {
      runner = new Thread(this);
      runner.start();
   }

   public void run () {
      area.setText("Starting..."+(i++)+"\n");
      MonitorFixed mgirl = new MonitorFixed (this, "Girl");
      MonitorFixed mboy = new MonitorFixed (this, "Boy");
      RunnerFixed girl = new RunnerFixed (mgirl, mboy, this);
      RunnerFixed boy = new RunnerFixed (mboy, mgirl, this);
      girl.start();
      if (((String)delay.getSelectedItem()).equals("Yes"))
	 try { runner.sleep(3000); } catch (Exception e) { }
      boy.start();
   }
}

public class DeadLockFixed extends Applet implements ActionListener {
   JButton go;

   public void init () {
      setLayout(new BorderLayout());
      add("Center", go = new JButton("Applet"));
      go.addActionListener(this);
   }

   public void actionPerformed (ActionEvent evt) {
      DFrameFixed s = new DFrameFixed();
      s.setSize(600,600);
      s.setVisible(true);
   }
}