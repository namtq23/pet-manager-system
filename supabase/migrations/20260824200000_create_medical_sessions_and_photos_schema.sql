-- ========================================================
-- Phase 3 Migration: Create Medical Sessions and Photos Schema & Storage RLS
-- Specification Reference: FT-003 (PHOTO-01, PHOTO-02, PHOTO-03)
-- ========================================================

-- 1. Create Medical Sessions Table (Lan kham)
CREATE TABLE IF NOT EXISTS public.medical_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    pet_id UUID NOT NULL REFERENCES public.pets(id) ON DELETE CASCADE,
    session_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    title TEXT NOT NULL,
    diagnosis TEXT,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by UUID REFERENCES auth.users(id)
);

-- 2. Create Medical Photos Table (Anh kham benh)
CREATE TABLE IF NOT EXISTS public.medical_photos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID NOT NULL REFERENCES public.medical_sessions(id) ON DELETE CASCADE,
    storage_path TEXT NOT NULL,
    public_url TEXT NOT NULL,
    caption TEXT,
    taken_at TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by UUID REFERENCES auth.users(id)
);

-- 3. Create Indexes
CREATE INDEX IF NOT EXISTS idx_medical_sessions_pet_id ON public.medical_sessions(pet_id);
CREATE INDEX IF NOT EXISTS idx_medical_sessions_date ON public.medical_sessions(session_date DESC);
CREATE INDEX IF NOT EXISTS idx_medical_photos_session_id ON public.medical_photos(session_id);

-- 4. Enable Row Level Security (RLS)
ALTER TABLE public.medical_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.medical_photos ENABLE ROW LEVEL SECURITY;

-- RLS Policies for Tables
CREATE POLICY "Active doctors can manage medical_sessions" ON public.medical_sessions
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE id = auth.uid() AND status = 'ACTIVE'
        )
    );

CREATE POLICY "Active doctors can manage medical_photos" ON public.medical_photos
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE id = auth.uid() AND status = 'ACTIVE'
        )
    );

-- 5. Supabase Storage Bucket Configuration
INSERT INTO storage.buckets (id, name, public)
VALUES ('medical-photos', 'medical-photos', true)
ON CONFLICT (id) DO NOTHING;

-- Storage RLS Policies
CREATE POLICY "Active doctors upload medical photos" ON storage.objects
    FOR INSERT WITH CHECK (
        bucket_id = 'medical-photos' AND
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE id = auth.uid() AND status = 'ACTIVE'
        )
    );

CREATE POLICY "Active doctors view medical photos" ON storage.objects
    FOR SELECT USING (
        bucket_id = 'medical-photos' AND
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE id = auth.uid() AND status = 'ACTIVE'
        )
    );

CREATE POLICY "Active doctors delete medical photos" ON storage.objects
    FOR DELETE USING (
        bucket_id = 'medical-photos' AND
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE id = auth.uid() AND status = 'ACTIVE'
        )
    );
