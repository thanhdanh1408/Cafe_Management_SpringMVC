package com.example.cafemanhdu.model;

<<<<<<< HEAD
import java.math.BigDecimal;

public class MenuItem {
	private int itemId;
	private String itemName;
	private BigDecimal price;
	private String status;

	public int getItemId() {
		return itemId;
	}

	public void setItemId(int itemId) {
		this.itemId = itemId;
	}

	public String getItemName() {
		return itemName;
	}

	public void setItemName(String itemName) {
		this.itemName = itemName;
	}

	public BigDecimal getPrice() {
		return price;
	}

	public void setPrice(BigDecimal price) {
		this.price = price;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
}
=======
public class MenuItem {
	 private int itemId;
	    private String itemName;
	    private double price;
	    private String status; // "available" or "unavailable"
		public int getItemId() {
			return itemId;
		}
		public void setItemId(int itemId) {
			this.itemId = itemId;
		}
		public String getItemName() {
			return itemName;
		}
		public void setItemName(String itemName) {
			this.itemName = itemName;
		}
		public double getPrice() {
			return price;
		}
		public void setPrice(double price) {
			this.price = price;
		}
		public String getStatus() {
			return status;
		}
		public void setStatus(String status) {
			this.status = status;
		}
}
>>>>>>> f2a4927b00b77d5f82f6fa9690eaaac0fb87e360
