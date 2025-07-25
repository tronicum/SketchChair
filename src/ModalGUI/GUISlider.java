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
import cc.sketchchair.core.KeyEventSK;
import cc.sketchchair.core.MouseEventSK;
import cc.sketchchair.sketch.LOGGER;
import processing.core.PGraphics;
import processing.core.PImage;
import cc.sketchchair.core.MouseEventSK;

public class GUISlider extends GUIComponent {
	public static final int HORIZONTAL = 0;
	public static final int VERTICAL = 1;
	float width;
	float maxVal;
	float minVal;
	public float curVal = 0f;
	boolean clickedOn = false;

	float selectArea = 17f;
	float trigSize = 14f;
	public int orientation = 0;
	private float clickOffsetX;
	private float mouseClickDeltaX;
	private float mouseClickDeltaY;
	private float scrollX;
	private float scrollY;
	
	PImage maxImg = null;
	PImage minImg = null;
	
	GUINumberfield currentValField = null;
	
	private boolean showValLabel = false;
	private String formatValLabel = null;
	private GUILabel labelVal ;
	private float labelValMultiplier = 1.0f;

	
	PImage handle;

	public GUISlider(float x, float y, float width, float minVal, float maxVal,
			int orientation, ModalGUI c) {
		this.setController(c);
		this.setPos(x, y);
		this.width = width;
		this.minVal = minVal;
		this.maxVal = maxVal;
		this.orientation = orientation;
		this.handle = controller.applet.loadImage("handle.png");
		labelVal = new GUILabel(0, 0, null, c);
		labelVal.preRenderLabels =false;
	}

	public GUISlider(float x, float y, float width, float minVal, float maxVal,
			ModalGUI c) {
		this.setController(c);
		this.setPos(x, y);
		this.width = width;
		this.minVal = minVal;
		this.maxVal = maxVal;
		this.handle = controller.applet.loadImage("handle.png");
		labelVal = new GUILabel(0, 0, null, c);
		labelVal.preRenderLabels =false;

	}
	
	public void addNumberField(){
		
		float maxImgW =0;
		if(this.maxImg!= null)
			maxImgW = this.maxImg.width;
		this.currentValField = new GUINumberfield(this.x+this.width+maxImgW+5,this.y,35,15,this.getController());
		this.currentValField.addActionListener(this, "setVal");
		
		if(this.parentPanel != null)
			this.parentPanel.add(this.currentValField );
		else
			this.getController().add(this.currentValField);

		this.currentValField.setValue(this.getVal());
	}

	private void changeval() {
		
		reRender();
		if (this.orientation == HORIZONTAL) {
			float mouseX = controller.applet.mouseX - mouseClickDeltaX;
			float mouseDelta = ((mouseX - this.getX()) / (this.width - selectArea));

			if (mouseDelta > 1)
				mouseDelta = 1;

			if (mouseDelta < 0)
				mouseDelta = 0;

			this.curVal = (((maxVal - minVal) * mouseDelta))+1;
			//if(this.curVal < minVal)
			//	this.curVal = minVal;
		} else {
			float mouseY = controller.applet.mouseY - mouseClickDeltaY;
			float mouseDelta = ((mouseY - this.getY()) / (this.width - (selectArea / 2)));

			if (mouseDelta > 1)
				mouseDelta = 1;

			if (mouseDelta < 0)
				mouseDelta = 0;

			this.curVal = (((maxVal - minVal) * mouseDelta));

			if (this.curVal < minVal)
				this.curVal = minVal;

		}
		//	listener.val = this.curVal;
		//	this.fireEventNotification(null, "");
		
		if(this.currentValField != null){
			this.currentValField.setValue(Math.round(this.curVal));
		}
		
		this.fireEventNotification(this.curVal);

	}

	public void setEndImgs(PImage _minImg , PImage _maxImg ){
		this.minImg = _minImg;
		this.maxImg = _maxImg;
		
	}
	private void clicked() {

		this.mouseClickDeltaX = controller.applet.mouseX
				- (this.getX() + this.scrollX);
		this.mouseClickDeltaY = controller.applet.mouseY
				- (this.getY() + this.scrollY);

	}

	public float getVal() {
		return curVal;
	}

	public boolean isMouseOver() {

		return isMouseOverDragPoint();
	}

	boolean isMouseOverDragPoint() {

		float mouseX = controller.applet.mouseX;
		float mouseY = controller.applet.mouseY;

		if (this.orientation == HORIZONTAL) {

			float scrollX = (this.width - selectArea)
					* (this.curVal / (maxVal - minVal));

			//scrollX += this.getX();

			return mouseX >= scrollX + this.getX() && mouseY >= this.getY()
					&& mouseX <= scrollX + this.getX() + (selectArea)
					&& mouseY <= this.getY() + (selectArea);
		} else {

			float scrollY = (this.width - selectArea)
					* (this.curVal / (maxVal - minVal));

			//	scrollY += this.getY();

			return mouseY >= scrollY + this.getY()
					&& mouseY <= scrollY + this.getY() + (selectArea)
					&& mouseX >= getX() - (selectArea / 2)
					&& mouseX <= getX() + (selectArea / 2);

		}
	}

	@Override
	public void keyEvent(KeyEventSK theKeyEvent) {
	}

	@Override
	public void mouseEvent(MouseEventSK e) {

		//
		if (e.getAction() == MouseEventSK.PRESS) {

			if (isMouseOverDragPoint()) {

				if (wasClicked == false)
					this.clicked();

				
				LOGGER.info("clicked");
				wasClicked = true;

			}

			//        if(isMouseOverDragPoint() && wasClicked){
			//    		//System.out.println("Moue over click");
			//
			//        	float scrollX  = width * (curVal/(maxVal-minVal));
			//        	
			//        	
			//        	scrollX += this.getX();
			//        	
			//            this.clickOffsetX = controller.parent.mouseX - scrollX;
			//           // System.out.println("clicked");
			//
			//        }

		} else if (e.getAction() == MouseEventSK.RELEASE && wasClicked) {
			fireEventNotification(this, "Clicked");
			wasClicked = false;
		}

	}

	@Override
	public void render(PGraphics g) {

		if (!this.visible)
			return;

		if (this.orientation == HORIZONTAL) {

			//fill colours
			if (this.getFillColour() != -2)
				g.fill(this.getFillColour());
			if (this.getStrokeColour() != -2)
				g.stroke(this.getStrokeColour());

			//g.rect(this.getX(), this.getY(), this.width,selectArea);
			g.strokeWeight(5);
			g.stroke(g.color(220, 220, 220));
			g.line(this.getX(), this.getY() + (selectArea / 2), this.getX()
					+ this.width, this.getY() + (selectArea / 2));

			g.strokeWeight(2);
			g.stroke(g.color(95, 95, 95));
			g.line(this.getX() + 2, this.getY() + (selectArea / 2), this.getX()
					+ this.width - 2, this.getY() + (selectArea / 2));

			this.scrollX = (this.width - selectArea)
					* (this.curVal / (maxVal - minVal));
			//scrollX += this.getX();
			//g.ellipseMode(0);
			

			g.fill(180, 180, 180);
			if (this.handle != null)
				g.image(this.handle, (int)(scrollX + this.getX()
						- (this.handle.width / 8)), (int)(this.getY()
						- (this.handle.height / 6)));
			else
				g.rect(scrollX + this.getX(), this.getY(), selectArea,
						selectArea);
			
			
			if(this.minImg != null)
				g.image(this.minImg,this.getX()-(this.minImg.width + 2), this.getY());
				
			
			if(this.maxImg != null)
				g.image(this.maxImg,this.getX()+(this.width + 2), this.getY()+(this.minImg.height/2));

		} else {

			g.stroke(200, 200, 200);
			g.noFill();
			g.strokeWeight(1);
			//fill colours
			if (this.getFillColour() != -2)
				g.fill(this.getFillColour());
			if (this.getStrokeColour() != -2)
				g.stroke(this.getStrokeColour());

			g.strokeWeight(5);
			g.stroke(g.color(220, 220, 220));
			g.line(this.getX(), this.getY(), this.getX(), this.getY()
					+ this.width);

			g.strokeWeight(2);
			g.stroke(g.color(95, 95, 95));
			g.line(this.getX(), this.getY(), this.getX(), this.getY()
					+ this.width);

			this.scrollY = (width - selectArea) * (curVal / (maxVal - minVal));
			//scrollY += this.getY();

			g.fill(180, 180, 180);
			if (this.handle != null)
				g.image(this.handle, (int)(this.getX() - (selectArea / 1.8f)), (int)(scrollY
						+ this.getY() - 2));
			else
				g.rect(this.getX() - (selectArea / 2), scrollY + this.getY(),
						selectArea, selectArea);

		}
		renderLabel(g);
	}

	@Override
	public void renderLabel(PGraphics g) {

		if (this.orientation == HORIZONTAL) {

			if (this.label != null) {
				this.label.align = GUILabel.LEFT;
				this.label.render(g, this.getX(), this.getY() - 15);
			}
			if(getShowValLabel()){
				

				float labelOffset = 0;
				if(this.label != null)	
				labelOffset = this.label.getWidth();
				
				if(getFormatValLabel() != null)
					this.labelVal.setText(String.format(getFormatValLabel(),(this.getVal()*getLabelValMultiplier()))+"");	
					else
				 this.labelVal.setText(String.format("%1$.2f",(this.getVal()*getLabelValMultiplier()))+"");	
			    
				this.labelVal.render(g, this.getX() + this.width+ labelOffset + 20, this.getY()+18);
			}
		} else {

			if (this.label != null) {
				this.label.align = GUILabel.LEFT;
				this.label.render(g, this.getX(), this.getY() + 22);
			}
			
			if(getShowValLabel()){
			
			float labelOffset = 0;
			if(this.label != null)	
			labelOffset = this.label.getWidth();
			if(getFormatValLabel() != null)
			this.labelVal.setText(String.format(getFormatValLabel(),(this.getVal()*getLabelValMultiplier()))+"");	
			else
			this.labelVal.setText(String.format("%.2g",(this.getVal()*getLabelValMultiplier()))+"");	
			this.labelVal.render(g, this.getX() + this.width+ labelOffset + 2, this.getY());
			}
			
			
		}

	}

	public void setMaxVal(float val) {
		this.maxVal = val;
	}

	public void setMinVal(float val) {
		this.minVal = val;
	}

	@Override
	public void setup() {
		// TODO Auto-generated method stub

	}

	public void setVal(float val) {
		this.curVal = val;
	}

	@Override
	public void update() {

		if (this.wasClicked)
			this.changeval();
	}

	/**
	 * @return the showValLabel
	 */
	public boolean getShowValLabel() {
		return showValLabel;
	}

	/**
	 * @param showValLabel the showValLabel to set
	 */
	public void setShowValLabel(boolean showValLabel) {
		this.showValLabel = showValLabel;
		}

	/**
	 * @return the labelValMultiplier
	 */
	public float getLabelValMultiplier() {
		return labelValMultiplier;
	}

	/**
	 * @param labelValMultiplier the labelValMultiplier to set
	 */
	public void setLabelValMultiplier(float labelValMultiplier) {
		this.labelValMultiplier = labelValMultiplier;
	}

	/**
	 * @return the formatValLabel
	 */
	public String getFormatValLabel() {
		return formatValLabel;
	}

	/**
	 * @param formatValLabel the formatValLabel to set
	 */
	public void setFormatValLabel(String formatValLabel) {
		this.formatValLabel = formatValLabel;
	}

}
