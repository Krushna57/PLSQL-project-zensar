# Customer Feedback Analysis System

## Project Overview
The **Customer Feedback Analysis System** is designed to store and analyze customer feedback for a product or service. The system incorporates SQL and PL/SQL functionalities to enable efficient data management and insightful analysis. Key features include feedback aggregation, common complaint identification, and activity logging to ensure comprehensive tracking of feedback updates.

## Features
1. **Feedback Aggregation:**
   - Analyze feedback by rating, product, and region.
   - Gain insights into customer satisfaction levels and trends.

2. **Complaint Identification:**
   - Use PL/SQL functions to identify the most common complaints across products or regions.

3. **Feedback Update Logging:**
   - Implement triggers to log feedback updates in an audit trail for accountability.

## Database Schema
The database consists of the following tables:
1.Region
2.Customer
3.Product
4.Feedback
5.Audit_Log
These table structure is provided in the project file named as 'tables.sql' with the data queries file named as 'data.sql'

**Description:** Maintains an audit trail of feedback updates with details about changes and responsible personnel.

## Key Tasks
1. **SQL for Feedback Analysis:**
   - Write SQL queries to aggregate feedback by product, region, and rating.

2. **PL/SQL for Complaint Identification:**
   - Develop PL/SQL functions to identify and prioritize common complaints from customer feedback.

3. **Triggers for Feedback Updates:**
   - Implement triggers to log feedback modifications into the `Audit_Log` table.

## Usage
1. Set up the database schema by running the provided SQL scripts to create the tables.
2. Populate the tables with provided sample data for testing.
3. Use SQL and PL/SQL scripts to perform analysis and identify complaints. (PL/SQL script is written in operations.sql file)
4. Ensure feedback updates are logged automatically by triggers.

## Future Enhancements
- Develop a web-based interface for customers to provide feedback.
- Add visualization tools to represent feedback trends.
- Integrate machine learning models to predict customer satisfaction.

## Authors
Developed by [Sahane Krushna].

