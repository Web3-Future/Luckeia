"use client"
import { Button } from "@/components/ui/button"
import React, { useState } from 'react'
import {
    Card,
    CardContent,
    CardDescription,
    CardFooter,
    CardHeader,
    CardTitle,
} from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import {
    Tabs,
    TabsContent,
    TabsList,
    TabsTrigger,
} from "@/components/ui/tabs"

export default function TabsDemo() {
    const [address, setAddress] = useState('');

    const handleAddressChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        const value = e.target.value;
        if (/^0x[a-fA-F0-9]*$/.test(value) || value === '') {
            setAddress(value);
        }
    };

    return (
        <Tabs defaultValue="s1" className="w-[400px]">
            <TabsList className="grid w-full grid-cols-4">
                <TabsTrigger value="s1">s1</TabsTrigger>
                <TabsTrigger value="s2">s2</TabsTrigger>
                <TabsTrigger value="s3">s3</TabsTrigger>
                <TabsTrigger value="c1">Customized</TabsTrigger>
            </TabsList>
            <TabsContent value="s1">
                <Card>
                    <CardHeader>
                        {/* <CardTitle>Account</CardTitle> */}
                        <CardDescription>
                            规则 1
                        </CardDescription>
                    </CardHeader>
                    <CardContent className="space-y-2">
                        <div className="space-y-1">
                            <Label htmlFor="amount1">Amount</Label>
                            <Input id="amount1" type="number" step="0.01" defaultValue="" />
                        </div>
                        <div className="space-y-1">
                            <Label htmlFor="maxWinners">Max Winners</Label>
                            <Input id="maxWinners" type="number" defaultValue="" />
                        </div>
                        <div className="space-y-1">
                            <Label htmlFor="address">Participants</Label>
                            <Input id="participants" type="text" defaultValue="" placeholder="0x..." />
                        </div>
                    </CardContent>

                    <CardFooter>
                        <Button>Submit</Button>
                    </CardFooter>
                </Card>
            </TabsContent>
            <TabsContent value="s2">
                <Card>
                    <CardHeader>
                        {/* <CardTitle>s2</CardTitle> */}
                        <CardDescription>
                            规则 2
                        </CardDescription>
                    </CardHeader>
                    <CardContent className="space-y-2">
                        <div className="space-y-1">
                            <Label htmlFor="current">Current password</Label>
                            <Input id="current" type="password" />
                        </div>
                        <div className="space-y-1">
                            <Label htmlFor="new">New password</Label>
                            <Input id="new" type="password" />
                        </div>
                    </CardContent>
                    <CardFooter>
                        <Button>Submit</Button>
                    </CardFooter>
                </Card>
            </TabsContent>
            <TabsContent value="s3">
                <Card>
                    <CardHeader>
                        {/* <CardTitle>s3</CardTitle> */}
                        <CardDescription>
                            策略 3
                        </CardDescription>
                    </CardHeader>
                    <CardContent className="space-y-2">
                        <div className="space-y-1">
                            <Label htmlFor="current">Current password</Label>
                            <Input id="current" type="password1" />
                        </div>
                        <div className="space-y-1">
                            <Label htmlFor="new">New password</Label>
                            <Input id="new" type="password1" />
                        </div>
                    </CardContent>
                    <CardFooter>
                        <Button>Submit</Button>
                    </CardFooter>
                </Card>
            </TabsContent>
            <TabsContent value="c1">
                <Card>
                    <CardHeader>
                        <CardTitle>Customized</CardTitle>
                        <CardDescription>
                            自定义策略
                        </CardDescription>
                    </CardHeader>
                    <CardContent className="space-y-2">
                        <div className="space-y-1">
                            <Label htmlFor="current">Current password</Label>
                            <Input id="current" type="Customized" />
                        </div>
                        <div className="space-y-1">
                            <Label htmlFor="new">New password</Label>
                            <Input id="new" type="Customized" />
                        </div>
                        <div className="space-y-1">
                            <Label htmlFor="current">Current password</Label>
                            <Input id="current" type="Customized" />
                        </div>
                        <div className="space-y-1">
                            <Label htmlFor="new">New password</Label>
                            <Input id="new" type="Customized" />
                        </div>
                        <div className="space-y-1">
                            <Label htmlFor="current">Current password</Label>
                            <Input id="current" type="Customized" />
                        </div>
                        <div className="space-y-1">
                            <Label htmlFor="new">New password</Label>
                            <Input id="new" type="Customized" />
                        </div>
                    </CardContent>
                    <CardFooter>
                        <Button>Submit</Button>
                    </CardFooter>
                </Card>
            </TabsContent>
        </Tabs>
    )
}
