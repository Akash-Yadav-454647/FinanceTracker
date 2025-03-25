/*
  # Enable storage for receipt images

  This migration creates a storage bucket for receipt images and sets up the necessary policies
  to allow authenticated users to upload and access their own receipt images.
*/

-- Create a storage bucket for receipt images
INSERT INTO storage.buckets (id, name, public)
VALUES ('receipts', 'receipts', false)
ON CONFLICT (id) DO NOTHING;

-- Set up storage policies
-- Allow users to insert their own files
CREATE POLICY "Users can upload their own receipt images"
  ON storage.objects
  FOR INSERT
  TO authenticated
  WITH CHECK (bucket_id = 'receipts' AND (storage.foldername(name))[1] = auth.uid()::text);

-- Allow users to select their own files
CREATE POLICY "Users can view their own receipt images"
  ON storage.objects
  FOR SELECT
  TO authenticated
  USING (bucket_id = 'receipts' AND (storage.foldername(name))[1] = auth.uid()::text);

-- Allow users to update their own files
CREATE POLICY "Users can update their own receipt images"
  ON storage.objects
  FOR UPDATE
  TO authenticated
  USING (bucket_id = 'receipts' AND (storage.foldername(name))[1] = auth.uid()::text);

-- Allow users to delete their own files
CREATE POLICY "Users can delete their own receipt images"
  ON storage.objects
  FOR DELETE
  TO authenticated
  USING (bucket_id = 'receipts' AND (storage.foldername(name))[1] = auth.uid()::text);