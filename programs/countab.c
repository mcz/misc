#include <X11/Xlib.h>
#include <X11/keysym.h>
#include <X11/XF86keysym.h>
#include <stdlib.h>
#include <stdio.h>
#include <signal.h>
#define ever (;;)

Display *dp;
Window tabbed;

void
turnon()
{
	if (system("(xrandr --listactivemonitors |grep eDP-1) &>/dev/null"))
		system("xrandr --output eDP-1 --auto");
}

void
turnoff()
{
	system("xrandr --output eDP-1 --off");
	XSetInputFocus(dp, RootWindow(dp, 1), RevertToPointerRoot, CurrentTime);

}

void
handle_key(XKeyPressedEvent *e)
{
	if (e->keycode == XKeysymToKeycode(dp, XK_T))
		system("sideterm &");
	else if (e->keycode == XKeysymToKeycode(dp, XK_F))
		system("sideterm bash -ic mc &");
	else if (e->keycode == XKeysymToKeycode(dp, XK_V))
		system("sideterm bash -ic vim &");
	else if (e->keycode == XKeysymToKeycode(dp, XF86XK_MonBrightnessUp))
		system("bash -c \"light -A 5; NotifyBright\"");
	else if (e->keycode == XKeysymToKeycode(dp, XF86XK_MonBrightnessDown))
		system("bash -c \"light -U 5; NotifyBright\"");
	else if (e->keycode == XKeysymToKeycode(dp, XK_space)) {
		if (e->state & ShiftMask)
			turnoff();
		else
			XSetInputFocus(dp, RootWindow(dp, 1), RevertToParent, e->time);
	}
}

void
focus_in(int signum)
{
	turnon();
	XSetInputFocus(dp, tabbed, RevertToParent, CurrentTime);
	XFlush(dp);
}

int
main()
{
	Window root, parent, *children;
	unsigned int n;
	XEvent ev;

	char *s = getenv("TABBED");
	if (!s) {
		fprintf(stderr, "$TABBED is not set");
		return 1;
	} else {
		tabbed = (Window) strtol(s, NULL, 0);
	}

	if (!(dp = XOpenDisplay(NULL))) {
		fprintf(stderr, "Can't open DISPLAY");
		return 2;
	}

	XSelectInput(dp, tabbed, SubstructureNotifyMask);
	XSelectInput(dp, DefaultRootWindow(dp), SubstructureRedirectMask);
	XGrabButton(dp, AnyButton, AnyModifier, tabbed, True, ButtonPressMask, GrabModeSync, GrabModeAsync, None, None);
	XGrabKey(dp, XKeysymToKeycode(dp, XK_T), Mod4Mask, tabbed, True, GrabModeAsync, GrabModeAsync);
	XGrabKey(dp, XKeysymToKeycode(dp, XK_F), Mod4Mask, tabbed, True, GrabModeAsync, GrabModeAsync);
	XGrabKey(dp, XKeysymToKeycode(dp, XK_V), Mod4Mask, tabbed, True, GrabModeAsync, GrabModeAsync);
	XGrabKey(dp, XKeysymToKeycode(dp, XF86XK_MonBrightnessUp), None, tabbed, True, GrabModeAsync, GrabModeAsync);
	XGrabKey(dp, XKeysymToKeycode(dp, XF86XK_MonBrightnessDown), None, tabbed, True, GrabModeAsync, GrabModeAsync);
	XGrabKey(dp, XKeysymToKeycode(dp, XK_space), Mod4Mask, tabbed, True, GrabModeAsync, GrabModeAsync);
	XGrabKey(dp, XKeysymToKeycode(dp, XK_space), ShiftMask | Mod4Mask, tabbed, True, GrabModeAsync, GrabModeAsync);

	signal(SIGUSR1, focus_in);

	for ever {
		XNextEvent(dp, &ev);
		switch (ev.type) {
			case CreateNotify:
				turnon();
				break;
			case DestroyNotify:
				if (XQueryTree(dp, tabbed, &root, &parent, &children, &n)) {
					XFree(children);
				} else {
					break;
				}
				if (n) {
					turnon();
				} else {
					turnoff();
				}
				break;
			case ButtonPress:
				XSetInputFocus(dp, (ev.xbutton.subwindow == None) ? ev.xbutton.window : ev.xbutton.subwindow, RevertToPointerRoot, ev.xbutton.time);
				XAllowEvents(dp, ReplayPointer, ev.xbutton.time);
				break;
			case KeyPress:
				handle_key(&ev.xkey);
				break;
			case MapRequest:
				XReparentWindow(dp, ev.xmaprequest.window, tabbed, 0, 0);
				XMapWindow(dp, ev.xmaprequest.window);
				break;
		}
	}
}
