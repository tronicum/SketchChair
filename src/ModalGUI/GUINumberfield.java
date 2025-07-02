/*******************************************************************************
 * This is part of SketchChair, an open-source tool for designing your own furniture.
 *     www.sketchchair.cc
 *     
 *     Copyright (C) 2012, Diatom Studio ltd.  Contact: hello@diatom.cc
 * 
 *     This program is free software: you can redistribute it and/or modify
 *     it under the terms of the GNU General Public License as published by
 *     the Free Software Foundation, either version 3 of the License, or
 *     (at your option) any later version.
 * 
 *     This program is distributed in the hope that it will be useful,
 *     but WITHOUT ANY WARRANTY; without even the implied warranty of
 *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *     GNU General Public License for more details.
 * 
 *     You should have received a copy of the GNU General Public License
 *     along with this program.  If not, see <http://www.gnu.org/licenses/>.
 ******************************************************************************/
package ModalGUI;

import java.awt.event.MouseWheelEvent;
import java.awt.event.MouseWheelListener;
import java.text.NumberFormat;

import processing.core.PApplet;
import cc.sketchchair.core.KeyEventSK;
import cc.sketchchair.core.MouseWheelEventSK;
import cc.sketchchair.sketch.LOGGER;

public class GUINumberfield extends GUITextfield {

	float val = 0;
	float incriment = .1f;
	String unit = "mm";

	public GUINumberfield(float x, float y, float w, float h, ModalGUI c) {
		super(x, y, w, h, c);
		this.setText("0");

		
	
		
	}

	public float getVal() {

		String text = getText();
		Float f;

		try {
			f = new Float(text);
		} catch (NumberFormatException e) {
			return 0;

		}

		return f.floatValue();
	}

	@Override
	public void mouseWheelMoved(MouseWheelEventSK e) {
		if(this.hasFocus()){
			
		float notches = (float)-e.getUnitsToScroll();
		float newVal = this.getVal()+(notches*this.incriment);
		newVal = (float) (Math.round(newVal*100.0) / 100.0);
		
		
		this.setText(newVal +"");
		this.updateField();
		}
	}
	
	@Override
	public void keyEvent(KeyEventSK theKeyEvent) {

		if (isTexfieldActive && isActive
				&& theKeyEvent.getAction() == KeyEventSK.PRESS) {
			if (theKeyEvent.getKeyCode() == PApplet.UP) {
				float v = getVal();
				v += incriment;
				NumberFormat nf = NumberFormat.getInstance();
				nf.setMaximumFractionDigits(2);
				this.setText(nf.format(v));
			} else if (theKeyEvent.getKeyCode() == PApplet.DOWN) {
				float v = getVal();
				v -= incriment;

				NumberFormat nf = NumberFormat.getInstance();
				nf.setMaximumFractionDigits(2);

				this.setText(nf.format(v));
			} else if (theKeyEvent.getKeyCode() == PApplet.LEFT) {
				if (myPosition > 0) {
					myPosition--;
				}
			} else if (theKeyEvent.getKeyCode() == PApplet.RIGHT) {
				if (myPosition < myTextline.length()) {
					myPosition++;
				}
			} else if (theKeyEvent.getKeyCode() ==PApplet.DELETE
					|| theKeyEvent.getKeyCode() == PApplet.BACKSPACE) {
				if (myTextline.length() > 0) {
					if (myPosition > 0) {
						myTextline.deleteCharAt(myPosition - 1);
						myPosition--;
					}
				}
			} else if (theKeyEvent.getKeyCode() == PApplet.ENTER) {
				submit();
			} else if (theKeyEvent.getKeyCode() != PApplet.SHIFT
					&& theKeyEvent.getKeyCode() != PApplet.ALT
					&& theKeyEvent.getKeyCode() != PApplet.ALT
					&& theKeyEvent.getKeyCode() != PApplet.CONTROL) {
				if (theKeyEvent.getKeyCode() >= 48
						&& theKeyEvent.getKeyCode() <= 57
						|| theKeyEvent.getKeyCode() == 46) {

					System.out.println(theKeyEvent.getKeyCode());
					myTextline.insert(myPosition, theKeyEvent.getKey());
					myPosition++;
				}
			}
			updateField();
		}
	}

	public void setText(String theValue) {
		myTextline = new StringBuffer(theValue);
		// myPosition = myTextline.length() - 1;
		_myStringValue = theValue;
		myPosition = myTextline.length();
		// _myValueLabel.setWithCursorPosition(myTextline.toString(), myPosition);
	}

	void setUnit(String unit) {

		this.unit = unit;
	}

	@Override
	protected void updateField() {
		this.fireEventNotification(getVal());
	}

}
