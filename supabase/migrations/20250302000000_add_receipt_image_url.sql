/*
  # Add receipt_image_url column to transactions table

  This migration adds a receipt_image_url column to the transactions table
  to store URLs to receipt images uploaded by users.
*/

ALTER TABLE transactions ADD COLUMN IF NOT EXISTS receipt_image_url TEXT;