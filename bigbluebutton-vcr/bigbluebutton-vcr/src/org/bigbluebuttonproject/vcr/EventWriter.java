/**
* BigBlueButton open source conferencing system - http://www.bigbluebutton.org/
*
* Copyright (c) 2008 by respective authors (see below).
*
* This program is free software; you can redistribute it and/or modify it under the
* terms of the GNU Lesser General Public License as published by the Free Software
* Foundation; either version 2.1 of the License, or (at your option) any later
* version.
*
* This program is distributed in the hope that it will be useful, but WITHOUT ANY
* WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
* PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
*
* You should have received a copy of the GNU Lesser General Public License along
* with this program; if not, write to the Free Software Foundation, Inc.,
* 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
* 
*/
package org.bigbluebuttonproject.vcr;

import java.io.PrintWriter;
import java.io.OutputStream;

import java.util.concurrent.locks.ReentrantLock;

/**
 * This class is used instead of PrintWriter to write to the XML file. Event are
 * received asynchronously, which means that one event handler can overlap another, in
 * principle. When that happens, incorrect XML will be produced. Avoid this by
 * serializing the write access to the XML document using java.concurrent.util.ReentrantLock.
 * 
 * @author michael.r.weiss
 *
 */
public class EventWriter extends PrintWriter {
	
	protected final ReentrantLock mutex;
	
	public EventWriter(OutputStream out) {
		super(out);
		mutex = new ReentrantLock();
	}
	
	/**
	 * Acquire a lock. Need this since events arrive asynchronously.
	 * Locks are reentrant (@see also java.util.concurrent).
	 */
	public void acquireLock() {
		mutex.lock();
	}
	
	/**
	 * Release a lock.
	 */
	public void releaseLock() {
		mutex.unlock();
	}
	
	public void print(String s) {
		if (mutex.isHeldByCurrentThread()) {
			// we are inside a critical section
			super.print(s);
		} else {
			mutex.lock();
			try {
				super.print(s);
			} finally {
				mutex.unlock();
			}
		}
	}
	
	public void println(String s) {
		if (mutex.isHeldByCurrentThread()) {
			// we are inside a critical section
			super.println(s);
		} else {
			mutex.lock();
			try {
				super.println(s);
			} finally {
				mutex.unlock();
			}
		}
	}
	
}
