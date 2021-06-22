import matplotlib.pyplot as plt
import matplotlib.patches as patches

class DraggablePoint:
    # klases instance aktyvavimui :
    # x,y,ax - klases kintamieji
    # iv - mazgo numeris (pradedant 0)
    # ITP - interpoliavimo klases Interpolation instance 

    lock = None         #only one can be animated at a time

    def __init__(self,x,y,ax,iv,ITP):   # instance konstruktorius
        self.x=x;self.y=y;self.ax=ax;
        self.ITP=ITP;  self.iv=iv; # tasku koordinates irasys, kuriose piesiama
        self.press = None;  self.background = None;
        # mazguose sukuriami skrituliai, kuriu ribose mazgas reaguoja i pele:
        self.point = patches.Circle((self.x[iv],self.y[iv]), 0.03, fc='r', alpha=0.8);
        (self.ax).add_patch(self.point); # skritulys vauzduojamas asyse
        print("DraggablePoint instance: point= %s, iv= %d" % (self.point , self.iv));

    def connect(self):  # connect to all the events we need
        self.cidpress = self.point.figure.canvas.mpl_connect('button_press_event', self.on_press);
        self.cidrelease = self.point.figure.canvas.mpl_connect('button_release_event', self.on_release);
        self.cidmotion = self.point.figure.canvas.mpl_connect('motion_notify_event', self.on_motion);

    def on_press(self, event):
        if event.inaxes != self.point.axes: return;
        if self.lock is not None: return;
        contains, attrd = self.point.contains(event);

        if not contains: return;
        self.press = (self.point.center), event.xdata, event.ydata  ; # nustatoma, kur yra skritulio centras ir kur yra pele paspaudimo metu
        c1=self.lock = self   # lock pazymimas pele nurodomas skritulys 

        # draw everything but the selected rectangle and store the pixel buffer:
        canvas = self.point.figure.canvas;   axes = self.point.axes;   self.point.set_animated(True);  canvas.draw();
        self.background = canvas.copy_from_bbox(self.point.axes.bbox)

        # now redraw just the rectangle and blit just the redrawn area
        axes.draw_artist(self.point); canvas.blit(axes.bbox)

    def on_motion(self, event):
        if self.lock is not self: return;            # reaguoja tik skritulys, pazymetas lock-u
        if event.inaxes != self.point.axes: return;            # nereaguoja, jeigu yra uz koord. sistemos ribu
        self.point.center, xpress, ypress = self.press;        # nustatoma, kur yra pele
        dx = event.xdata - xpress; dy = event.ydata - ypress;  # xdata ir ydata yra koordinates koord.asyse
        
        self.point.center = (self.point.center[0]+dx, self.point.center[1]+dy);

        # kreives perbraizymas:
        self.x[self.iv]=self.point.center[0]; self.y[self.iv]=self.point.center[1];
        ((self.ITP).h1).remove();  ((self.ITP).h2).remove();   # naikinama kreive ir mazgai
        (self.ITP).interpolatedCurve(self.x,self.y,self.ax)  # mazgai ir asys priklauso klasei DraggablePoint
        plt.draw();  #plt.pause(0.01)
                
        canvas = self.point.figure.canvas;  axes = self.point.axes
        canvas.restore_region(self.background);  # restore the background region      
        axes.draw_artist(self.point);  # redraw just the current rectangle        
        canvas.blit(axes.bbox);   # blit just the redrawn area

    def on_release(self, event): # on release we reset the press data
        if self.lock is not self: return;
        self.press = None; self.lock = None;      
        self.point.set_animated(False); self.background = None;   # turn off the rect animation property and reset the background    
        self.point.figure.canvas.draw();  # redraw the full figure  

    def disconnect(self): # disconnect all the stored connection ids
        self.point.figure.canvas.mpl_disconnect(self.cidpress)
        self.point.figure.canvas.mpl_disconnect(self.cidrelease)
        self.point.figure.canvas.mpl_disconnect(self.cidmotion)
